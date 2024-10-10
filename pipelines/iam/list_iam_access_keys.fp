pipeline "list_iam_access_keys" {
  title       = "List IAM Access Keys"
  description = "Returns information about the access key IDs associated with the specified IAM user. If no user is specified, the user name defaults to the current user."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
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

    env = param.conn.env
  }

  output "access_keys" {
    description = "A list of objects containing metadata about the access keys."
    value       = jsondecode(step.container.list_iam_access_keys.stdout).AccessKeyMetadata
  }
}
