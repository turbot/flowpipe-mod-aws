pipeline "put_iam_role_policy" {
  title       = "Put IAM Role Policy"
  description = "Adds or updates an inline policy document that is embedded in the specified IAM role."

  param "access_key_id" {
    type        = string
    description = local.access_key_id_param_description
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = local.secret_access_key_param_description
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
    image = "public.ecr.aws/aws-cli/aws-cli"
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
}
