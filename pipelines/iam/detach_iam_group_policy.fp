pipeline "detach_iam_group_policy" {
  title       = "Detach IAM Group Policy"
  description = "Detaches a policy from an IAM group."

  param "cred" {
    type        = string
    description = "The AWS credentials to use for detaching the policy."
    default     = "default"
  }

  param "group_name" {
    type        = string
    description = "The name of the IAM group from which the policy will be detached."
  }

  param "policy_arn" {
    type        = string
    description = "The ARN of the IAM policy to be detached from the group."
  }

  step "container" "detach_policy" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["iam", "detach-group-policy"],
      ["--group-name", param.group_name],
      ["--policy-arn", param.policy_arn],
    )

    env = credential.aws[param.cred].env
  }

  output "result" {
    description = "Confirmation message that the policy has been detached from the group."
    value       = "Policy ${param.policy_arn} has been detached from group ${param.group_name}."
  }
}
