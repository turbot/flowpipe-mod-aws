pipeline "attach_role_policy" {
  title       = "Attach policy to role"
  description = "Attaches the specified managed policy to the specified IAM role. When you attach a managed policy to a role, the managed policy becomes part of the role's permission (access) policy."

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
    description = "The name (friendly name, not ARN) of the role to attach the policy to."
  }

  param "policy_arn" {
    type        = string
    description = "The Amazon Resource Name (ARN) of the IAM policy you want to attach."
  }

  step "container" "attach_role_policy" {
    image = "amazon/aws-cli"
    cmd = [
      "iam", "attach-role-policy",
      "--role-name", param.role_name,
      "--policy-arn", param.policy_arn,
    ]

    env = {
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    value = step.container.attach_role_policy.stdout
  }

   output "stderr" {
    value = step.container.attach_role_policy.stderr
  }
}
