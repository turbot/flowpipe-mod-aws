pipeline "describe_iam_instance_profile_associations" {
  title       = "Describe IAM Instance Profile Associations"
  description = "Describes your IAM instance profile associations."

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

  param "instance_id" {
    type        = string
    description = "The ID of the instance."
    optional    = true
  }

  step "container" "describe_iam_instance_profile_associations" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["ec2", "describe-iam-instance-profile-associations"],
      param.instance_id != null ? ["--filters", "Name=instance-id,Values=${param.instance_id}"] : [],
    )

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = jsondecode(step.container.describe_iam_instance_profile_associations.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.describe_iam_instance_profile_associations.stderr
  }
}
