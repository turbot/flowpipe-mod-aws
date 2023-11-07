pipeline "list_iam_access_keys" {
  title       = "List Access Keys"
  description = "Returns information about the access key IDs associated with the specified IAM user. If no user is specified, the user name defaults to the current user."

  param "region" {
    type        = string
    description = "The name of the Region."
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

  param "user_name" {
    type        = string
    description = "The name of the user whose access keys you want to list."
    optional    = true
  }

  step "container" "list_iam_access_keys" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["iam", "list-access-keys"],
      param.user_name != null ? ["--user-name", "${param.user_name}"] : []
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "List of access keys and their metadata."
    value       = jsondecode(step.container.list_iam_access_keys.stdout)
  }

  output "stderr" {
    value = step.container.list_iam_access_keys.stderr
  }
}
