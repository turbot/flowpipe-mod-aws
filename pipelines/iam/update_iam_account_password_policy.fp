pipeline "update_iam_account_password_policy" {
  title       = "Update IAM Account Password Policy"
  description = "Updates the account password policy for the AWS account."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "minimum_password_length" {
    type        = number
    description = "The minimum length of the password."
    optional    = true
  }

  param "require_symbols" {
    type        = bool
    description = "Specifies whether to require symbols in the password."
    optional    = true
  }

  param "require_numbers" {
    type        = bool
    description = "Specifies whether to require numbers in the password."
    optional    = true
  }

  param "require_uppercase_characters" {
    type        = bool
    description = "Specifies whether to require uppercase characters in the password."
    optional    = true
  }

  param "require_lowercase_characters" {
    type        = bool
    description = "Specifies whether to require lowercase characters in the password."
    optional    = true
  }

  param "allow_users_to_change_password" {
    type        = bool
    description = "Allows users to change their own password."
    optional    = true
  }

  param "max_password_age" {
    type        = number
    description = "The number of days that an user password is valid."
    optional    = true
  }

  param "password_reuse_prevention" {
    type        = number
    description = "Prevents the reuse of the specified number of previous passwords."
    optional    = true
  }

  step "container" "update_iam_account_password_policy" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["iam", "update-account-password-policy"],
      param.minimum_password_length != null ? ["--minimum-password-length", tostring(param.minimum_password_length)] : [],
      param.require_symbols ? ["--require-symbols"] : [],
      param.require_numbers ? ["--require-numbers"] : [],
      param.require_uppercase_characters ? ["--require-uppercase-characters"] : [],
      param.require_lowercase_characters ? ["--require-lowercase-characters"] : [],
      param.allow_users_to_change_password ? ["--allow-users-to-change-password"] : [],
      param.max_password_age > 0 ? ["--max-password-age", tostring(param.max_password_age)] : [],
      param.password_reuse_prevention > 0 ? ["--password-reuse-prevention", tostring(param.password_reuse_prevention)] : []
    )

    env = param.conn.env
  }
}
