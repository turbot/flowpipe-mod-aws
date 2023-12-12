pipeline "delete_iam_user" {
  title       = "Delete IAM User"
  description = "Deletes an IAM user."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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
    env = credential.aws[param.cred].env
  }
}
