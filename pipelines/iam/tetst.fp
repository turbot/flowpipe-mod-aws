pipeline "deactivate_access_key_and_disable_console_access" {
  title       = "Deactivate Access Key and Disable Console Access"
  description = "Deactivates the IAM user's access key and disables console access by deleting the login profile."

  param "cred" {
    type        = string
    description = "The credentials to use for AWS CLI commands."
    default     = "default"
  }

  param "user_name" {
    type        = string
    description = "The name of the IAM user."
  }

  // param "access_key_id" {
  //   type        = string
  //   description = "The access key ID of the IAM user."
  // }

  param "disable_console_access" {
    type        = bool
    description = "Whether to disable console access by deleting the login profile."
    default     = true
  }

  step "container" "delete_login_profile" {
    if = param.disable_console_access
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "iam", "delete-login-profile",
      "--user-name", param.user_name
    ]

    env = credential.aws[param.cred].env
  }
}
