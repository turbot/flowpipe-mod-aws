pipeline "stop_ec2_instances" {
  title       = "Stop EC2 Instances"
  description = "Stops an Amazon EBS-backed instance."

  param "region" {
    type        = string
    description = "The name of the region."
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
    description = "The IDs of the instances."
  }

  step "container" "stop_ec2_instances" {
    image = "amazon/aws-cli"
    cmd = concat(
      ["ec2", "stop-instances", "--instance-ids"],
      param.instance_ids
    )
    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value = jsondecode(step.container.stop_ec2_instances.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value = jsondecode(step.container.stop_ec2_instances.stderr)
  }
}
