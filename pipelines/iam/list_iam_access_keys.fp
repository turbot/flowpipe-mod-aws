pipeline "list_iam_access_keys" {
  title       = "List Access Keys"
  description = "Returns information about the access key IDs associated with the specified IAM user. If no user is specified, the user name defaults to the current user."

  tags = {
    type = "featured"
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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

    env = credential.aws[param.cred].env
  }

  output "access_keys" {
    description = "A list of objects containing metadata about the access keys."
    value       = jsondecode(step.container.list_iam_access_keys.stdout).AccessKeyMetadata
  }
}
