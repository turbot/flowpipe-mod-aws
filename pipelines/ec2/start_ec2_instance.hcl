pipeline "start_ec2_instance" {

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

    param "instance_id" {
      type        = string
      description = "The IDs of the instances."
    }

    step "container" "start_ec2_instance" {
        image = "amazon/aws-cli"
        cmd = ["ec2", "start-instances", "--instance-ids", param.instance_id]
        env = {
            AWS_REGION            = param.aws_region
            AWS_ACCESS_KEY_ID     = param.aws_access_key_id
            AWS_SECRET_ACCESS_KEY = param.aws_secret_access_key
        }
    }

    output "stdout" {
        value = step.container.container_run_aws.stdout
    }

     output "stderr" {
        value = step.container.container_run_aws.stderr
    }
}
