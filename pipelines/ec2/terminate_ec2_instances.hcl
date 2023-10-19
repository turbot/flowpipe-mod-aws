pipeline "terminate_ec2_instances" {
  title       = "Terminate EC2 Instances"
  description = "Terminates one or more Amazon EC2 instances."

  param "region" {
    type        = string
    description = "The name of the Region."
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = "The ID for this access key."
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = "The secret key used to sign requests."
    default     = var.secret_access_key
  }

  param "instance_ids" {
    type        = list(string)
    description = "A list of EC2 instance IDs to terminate."
  }

  step "container" "terminate_instances" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["ec2", "terminate-instances"],
      try(length(param.instance_ids), 0) > 0 ? concat(["--instance-ids"], param.instance_ids) : [],
    )

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The JSON output from the AWS CLI."
    value       = jsondecode(step.container.terminate_instances.stdout)
  }

  output "stderr" {
    description = "The error output from the AWS CLI."
    value       = step.container.terminate_instances.stderr
  }
}
