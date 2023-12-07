pipeline "update_iam_access_key_status" {
  title       = "Update Access Key"
  description = "Changes the status of the specified access key from Active to Inactive, or vice versa. This is useful when you want to rotate access keys or to disable an access key temporarily."

  tags = {
    type = "featured"
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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

    env = credential.aws[param.cred].env
  }
}
