pipeline "update_iam_access_key_status" {
  title       = "Update Access Key"
  description = "Changes the status of the specified access key from Active to Inactive, or vice versa. This is useful when you want to rotate access keys or to disable an access key temporarily."

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

  param "user_access_key_id" {
    type        = string
    description = "The access key ID for the access key ID and secret access key you want to update."
  }

  param "status" {
    type        = string
    description = "The status you want to assign to the access key. Valid values: Active | Inactive"
  }

  param "user_name" {
    type        = string
    description = "The name of the user whose key you want to update."
    optional    = true
  }

  step "container" "update_iam_access_key_status" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["iam", "update-access-key"],
      ["--access-key-id", param.user_access_key_id],
      ["--status", param.status],
      param.user_name != null ? ["--user-name", param.user_name] : []
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "Confirmation message of access key status update."
    value       = step.container.update_iam_access_key_status.stdout
  }
}
