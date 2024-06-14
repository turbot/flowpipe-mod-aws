pipeline "change_iam_password" {
  title       = "Change IAM User Password"
  description = "Changes the password of the specified IAM user."

  param "cred" {
    type        = string
    description = "The name of the credential to use."
    default     = "default"
  }

  param "user_name" {
    type        = string
    description = "The name of the IAM user whose password you want to change."
  }

  param "old_password" {
    type        = string
    description = "The current password of the IAM user."
  }

  param "new_password" {
    type        = string
    description = "The new password for the IAM user."
  }

  step "container" "change_password" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "iam", "change-password",
      "--old-password", param.old_password,
      "--new-password", param.new_password,
    ]

    env = credential.aws[param.cred].env
  }
}
