pipeline "detach_iam_role_policy" {
  title       = "Detach IAM Role Policy"
  description = "Detaches a policy from an IAM role."

  param "cred" {
    type        = string
    description = "The AWS credentials to use for detaching the policy."
    default     = "default"
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

    env = credential.aws[param.cred].env
  }

  output "result" {
    description = "Confirmation message that the policy has been detached from the role."
    value       = "Policy ${param.policy_arn} has been detached from role ${param.role_name}"
  }
}
