pipeline "test_create_ec2_instance" {
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

  step "pipeline" "describe_ec2_instances" {
    if = !is_error(step.pipeline.run_ec2_instance)
    pipeline = pipeline.describe_ec2_instances
    args = {
      region            = param.region
      access_key_id     = param.access_key_id
      secret_access_key = param.secret_access_key
      instance_ids      = [step.pipeline.run_ec2_instance.output.instance.InstanceId]
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "terminate_ec2_instances" {
    if = !is_error(step.pipeline.run_ec2_instance)
    # Don't run before we've had a chance to describe the instance
    depends_on = [step.pipeline.describe_ec2_instances]

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
      "describe_ec2_instances" = !is_error(step.pipeline.describe_ec2_instances) ? "pass" : "fail: ${error_message(step.pipeline.describe_ec2_instances)}"
      "terminate_ec2_instances" = !is_error(step.pipeline.terminate_ec2_instances) ? "pass" : "fail: ${error_message(step.pipeline.terminate_ec2_instances)}"
    }
  }

}
