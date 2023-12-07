pipeline "test_start_and_stop_ec2_instance" {
  title       = "Test Start and Stop EC2 Instance"
  description = "Tests the start_ec2_instances and the start_ec2_instances pipelines."

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
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

  step "pipeline" "run_ec2_instances" {
    pipeline = pipeline.run_ec2_instances
    args = {
      region        = param.region
      instance_type = param.instance_type
      image_id      = param.image_id
    }
  }

  step "pipeline" "stop_ec2_instances" {
    if = !is_error(step.pipeline.run_ec2_instances)
    pipeline = pipeline.stop_ec2_instances
    args = {
      region       = param.region
      instance_ids = [step.pipeline.run_ec2_instances.output.instances[0].InstanceId]
    }

    # Wait for the instance to be in running state
    retry {
      max_attempts = 5
      min_interval = "5000"
    }
  }

  step "pipeline" "start_ec2_instances" {
    if = !is_error(step.pipeline.stop_ec2_instances)
    depends_on = [step.pipeline.stop_ec2_instances]
    pipeline = pipeline.start_ec2_instances
    args = {
      region       = param.region
      instance_ids = [step.pipeline.run_ec2_instances.output.instances[0].InstanceId]
    }

    # Wait for the instance to be in stopped state
    retry {
      max_attempts = 5
      min_interval = "5000"
    }
  }

  step "pipeline" "terminate_ec2_instances" {
    if = !is_error(step.pipeline.run_ec2_instances)
    # Don't run before we've had a chance to stop and start the instance
    depends_on = [step.pipeline.start_ec2_instances]

    pipeline = pipeline.terminate_ec2_instances
    args = {
      region       = param.region
      instance_ids = [step.pipeline.run_ec2_instances.output.instances[0].InstanceId]
    }
  }

  output "created_instance_id" {
    description = "Instance used in the test."
    value       = step.pipeline.run_ec2_instances.output.instances[0].InstanceId
  }

  output "test_results" {
    description = "Test results for each step."
    value       = {
      "run_ec2_instances" = !is_error(step.pipeline.run_ec2_instances) ? "pass" : "fail: ${error_message(step.pipeline.run_ec2_instances)}"
      "stop_ec2_instances" = !is_error(step.pipeline.stop_ec2_instances) ? "pass" : "fail: ${error_message(step.pipeline.stop_ec2_instances)}"
      "start_ec2_instances" = !is_error(step.pipeline.start_ec2_instances) ? "pass" : "fail: ${error_message(step.pipeline.start_ec2_instances)}"
      "terminate_ec2_instances" = !is_error(step.pipeline.terminate_ec2_instances) ? "pass" : "fail: ${error_message(step.pipeline.terminate_ec2_instances)}"
    }
  }

}
