pipeline "delete_iam_role" {
  title       = "Delete IAM Role"
  description = "Deletes an IAM role."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "role_name" {
    type        = string
    description = "The name of the role to delete."
  }

  step "container" "delete_role" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd   = ["iam", "delete-role", "--role-name", param.role_name]
    env   = param.conn.env
  }
}
