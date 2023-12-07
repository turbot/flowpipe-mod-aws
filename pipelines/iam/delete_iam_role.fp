pipeline "delete_iam_role" {
  title = "Delete IAM Role"
  description = "Deletes an IAM role."

  tags = {
    type = "featured"
  }

  param "cred" {
    type = string
    description = local.cred_param_description
    default = "default"
  }

  param "role_name" {
    type        = string
    description = "The name of the role to delete."
  }

  step "container" "delete_role" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd   = ["iam", "delete-role", "--role-name", param.role_name]
    env   = credential.aws["default"].env
  }
}
