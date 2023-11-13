pipeline "describe_iam_ec2_instance_profile_associations" {
  title       = "Describe IAM Instance Profile Associations"
  description = "Describe IAM instance profile associations for EC2 instances in AWS."

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

  param "filters" {
    type        = string
    description = "One or more filters. The possible values are: instance-id, iam-instance-profile. The filters limit the results to only the instance profile associations that match the filter criteria. If there are no matches, the response returns an empty list."
    optional    = true
  }

  step "container" "describe_iam_ec2_instance_profile_associations" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["ec2", "describe-iam-instance-profile-associations"],
      param.filters != null ? ["--filters", param.filters] : [],
    )

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = jsondecode(step.container.describe_iam_ec2_instance_profile_associations.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.describe_iam_ec2_instance_profile_associations.stderr
  }
}
