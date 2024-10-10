pipeline "delete_iam_user" {
  title       = "Delete IAM User"
  description = "Deletes an IAM user."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "user_name" {
    type        = string
    description = "The name of the user to delete."
  }

  step "container" "delete_user" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "iam",
      "delete-user",
      "--user-name", param.user_name
    ]
    env = param.conn.env
  }
}
