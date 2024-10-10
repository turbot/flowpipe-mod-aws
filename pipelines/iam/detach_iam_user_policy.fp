pipeline "detach_iam_user_policy" {
  title       = "Detach IAM User Policy"
  description = "Detaches the specified managed policy from the specified IAM user. When you detach a managed policy from a user, the user no longer has the permissions defined in that policy."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "user_name" {
    type        = string
    description = "The name (friendly name, not ARN) of the user to detach the policy from."
  }

  param "policy_arn" {
    type        = string
    description = "The Amazon Resource Name (ARN) of the IAM policy you want to detach."
  }

  step "container" "detach_user_policy" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "iam", "detach-user-policy",
      "--user-name", param.user_name,
      "--policy-arn", param.policy_arn,
    ]

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }
}
