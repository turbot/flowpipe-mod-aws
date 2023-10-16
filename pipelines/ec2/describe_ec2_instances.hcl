pipeline "describe_ec2_instances" {
    # Credentials
    param "aws_region" {
      type        = string
      description = "AWS Region"
      default     = var.aws_region
    }

    param "aws_access_key_id" {
      type        = string
      description = "AWS Access Key ID"
      default     = var.aws_access_key_id
    }

    param "aws_secret_access_key" {
      type        = string
      description = "AWS Secret Access Key"
      default     = var.aws_secret_access_key
    }

    param "instance_id" {
        type = string
    }

    step "container" "container_run_aws" {
        image = "amazon/aws-cli"
        cmd = ["ec2", "describe-instances", "--instance-ids", param.instance_id]
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
