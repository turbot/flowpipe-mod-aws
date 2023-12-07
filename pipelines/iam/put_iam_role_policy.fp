pipeline "put_iam_role_policy" {
  title       = "Put IAM Role Policy"
  description = "Adds or updates an inline policy document that is embedded in the specified IAM role."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "iam", "put-role-policy",
      "--role-name", param.role_name,
      "--policy-name", param.policy_name,
      "--policy-document", param.policy_document,
    ]

    env = credential.aws[param.cred].env
  }
}
