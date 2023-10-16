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

    param "instance_ids" {
      type     = list(string)
      # TODO: Should we use [] or optional = true?
      #default = []
      optional = true
    }

    param "instance_type" {
      type        = string
      description = "The type of instance (for example, t2.micro)."
      optional    = true
    }

    param "ebs_optimized" {
      type        = bool
      description = "A Boolean that indicates whether the instance is optimized for Amazon EBS I/O."
      optional    = true
    }


    param "filter" {
        type = string
        optional = true
    }

    step "container" "container_run_aws" {
        image = "amazon/aws-cli"

        cmd = concat(
          ["ec2", "describe-instances"],
          # TODO: Do I need to check for empty list to?
          param.instance_ids != nil && length(param.instance_ids) > 0 ? concat(["--instance-ids"], param.instance_ids) : [],
          param.instance_type != nil ? ["--filters", "Name=instance-type,Values=${param.instance_type}"]) : [],
          param.instance_type != nil ? ["--filters", "Name=ebs-optimized,Values=${param.ebs_optimized}"]) : [],
        )

        env = {
            AWS_REGION            = param.aws_region
            AWS_ACCESS_KEY_ID     = param.aws_access_key_id
            AWS_SECRET_ACCESS_KEY = param.aws_secret_access_key
        }
    }
    output "stdout" {
        value = jsondecode(step.container.container_run_aws.stdout)
    }
    output "stderr" {
        value = jsondecode(step.container.container_run_aws.stderr)
    }
}
