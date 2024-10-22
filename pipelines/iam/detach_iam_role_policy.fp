pipeline "detach_iam_role_policy" {
  title       = "Detach IAM Role Policy"
  description = "Detaches a policy from an IAM role."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "role_name" {
    type        = string
    description = "The name of the IAM role from which the policy will be detached."
  }

  param "policy_arn" {
    type        = string
    description = "The ARN of the IAM policy to be detached from the role."
  }

  step "container" "detach_policy" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["iam", "detach-role-policy"],
      ["--role-name", param.role_name],
      ["--policy-arn", param.policy_arn]
    )

    env = param.conn.env
  }

  output "result" {
    description = "Confirmation message that the policy has been detached from the role."
    value       = "Policy ${param.policy_arn} has been detached from role ${param.role_name}"
  }
}
