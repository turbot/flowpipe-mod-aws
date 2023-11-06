pipeline "list_iam_groups_for_user" {
  title       = "List IAM Groups for User"
  description = "Lists the IAM groups that the specified IAM user belongs to."

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

  param "user_name" {
    type        = string
    description = "The name of the user to list groups for."
  }

  step "container" "list_groups_for_user" {
    image = "amazon/aws-cli"
    cmd = [
      "iam", "list-groups-for-user",
      "--user-name", param.user_name
    ]

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = step.container.list_groups_for_user.stdout
  }

  output "stderr" {
    description = "The error output from the AWS CLI."
    value       = step.container.list_groups_for_user.stderr
  }
}
