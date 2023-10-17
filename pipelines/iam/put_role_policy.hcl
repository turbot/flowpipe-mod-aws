pipeline "put_role_policy" {
  title       = "Put inline policy to role"
  description = "Adds or updates an inline policy document that is embedded in the specified IAM role."

  param "access_key_id" {
    type        = string
    description = "The ID for this access key."
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = "The secret key used to sign requests."
    default     = var.secret_access_key
  }

  param "role_name" {
    type        = string
    description = "The name of the role to associate the policy with."
  }

  param "policy_name" {
    type        = string
    description = "The name of the policy document."
  }

  param "policy_document" {
    type        = string
    description = "The policy document."
  }

  step "container" "put_role_policy" {
    image = "amazon/aws-cli"
    cmd = [
      "iam", "put-role-policy",
      "--role-name", param.role_name,
      "--policy-name", param.policy_name,
      "--policy-document", param.policy_document,
    ]

    env = {
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    value = step.container.put_role_policy.stdout
  }

   output "stderr" {
    value = step.container.put_role_policy.stderr
  }
}
