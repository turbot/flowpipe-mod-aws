# TODO: Should this be capable of starting more than 1?
# It is more useful but harder to run for just 1 instance
pipeline "start_ec2_instances" {
  title       = "Start EC2 Instances"
  description = "Starts an Amazon EBS-backed instance that you've previously stopped."

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
    description = "The IDs of the instances."
  }

  step "container" "start_ec2_instances" {
    image = "amazon/aws-cli"
    cmd = concat(
      ["ec2", "start-instances", "--instance-ids"],
      param.instance_ids
    )
    env = {
        AWS_REGION            = param.region
        AWS_ACCESS_KEY_ID     = param.access_key_id
        AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    value = step.container.start_ec2_instances.stdout
  }

   output "stderr" {
    value = step.container.start_ec2_instances.stderr
  }
}
