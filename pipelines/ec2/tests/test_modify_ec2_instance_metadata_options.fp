pipeline "test_modify_ec2_instance_metadata_options" {
  title       = "Test Run EC2 Instance"
  description = "Test the run_ec2_instance pipeline."

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = local.access_key_id_param_description
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = local.secret_access_key_param_description
    default     = var.secret_access_key
  }

  param "instance_type" {
    type        = string
    description = "The EC2 instance type (e.g., t2.micro)."
    default     = "t2.micro"
  }

  param "image_id" {
    type        = string
    description = "The ID of the Amazon Machine Image (AMI) to launch."
    default     = "ami-041feb57c611358bd"
  }

  step "pipeline" "run_ec2_instance" {
    pipeline = pipeline.run_ec2_instance
    args = {
      region            = param.region
      access_key_id     = param.access_key_id
      secret_access_key = param.secret_access_key
      instance_type     = param.instance_type
      image_id          = param.image_id
    }
  }

  step "pipeline" "modify_ec2_instance_metadata_options" {
    if = !is_error(step.pipeline.run_ec2_instance)
    pipeline = pipeline.modify_ec2_instance_metadata_options
    args = {
      region            = param.region
      access_key_id     = param.access_key_id
      secret_access_key = param.secret_access_key
      instance_id      = step.pipeline.run_ec2_instance.output.instance.InstanceId
      http_tokens       = "required"
      http_endpoint     = "enabled"
    }

    # Wait for the instance to be in running state
    retry {
      max_attempts = 5
      min_interval = "5000"
    }

    error {
      ignore  = true
    }

  }

  step "pipeline" "terminate_ec2_instances" {
    if = !is_error(step.pipeline.run_ec2_instance)
    # Don't run before we've had a chance to describe the instance
    depends_on = [step.pipeline.modify_ec2_instance_metadata_options]

    pipeline = pipeline.terminate_ec2_instances
    args = {
      region            = param.region
      access_key_id     = param.access_key_id
      secret_access_key = param.secret_access_key
      instance_ids      = [step.pipeline.run_ec2_instance.output.instance.InstanceId]
    }
  }

  output "created_instance_id" {
    description = "Instance used in the test."
    value       = step.pipeline.run_ec2_instance.output.instance.InstanceId
  }

  output "test_results" {
    description = "Test results for each step."
    value       = {
      "run_ec2_instance" = !is_error(step.pipeline.run_ec2_instance) ? "pass" : "fail: ${error_message(step.pipeline.run_ec2_instance)}"
      "modify_ec2_instance_metadata_options" = !is_error(step.pipeline.modify_ec2_instance_metadata_options) ? "pass" : "fail: ${error_message(step.pipeline.modify_ec2_instance_metadata_options)}"
      "terminate_ec2_instances" = !is_error(step.pipeline.terminate_ec2_instances) ? "pass" : "fail: ${error_message(step.pipeline.terminate_ec2_instances)}"
    }
  }

}
