pipeline "delete_iam_policy" {
  title       = "Delete IAM Policy"
  description = "Deletes an IAM policy."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "policy_arn" {
    type        = string
    description = "The ARN of the policy to delete."
  }

  step "container" "delete_policy" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd   = ["iam", "delete-policy", "--policy-arn", param.policy_arn]
    env   = credential.aws["default"].env
  }
}
