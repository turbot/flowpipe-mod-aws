pipeline "describe_iam_instance_profile_associations" {
  title       = "Describe IAM Instance Profile Associations"
  description = "Describes your IAM instance profile associations."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "instance_id" {
    type        = string
    description = "The ID of the instance."
    optional    = true
  }

  step "container" "describe_iam_instance_profile_associations" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "describe-iam-instance-profile-associations"],
      param.instance_id != null ? ["--filters", "Name=instance-id,Values=${param.instance_id}"] : [],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "iam_instance_profile_associations" {
    description = "Information about the IAM instance profile associations."
    value       = jsondecode(step.container.describe_iam_instance_profile_associations.stdout).IamInstanceProfileAssociations
  }
}
