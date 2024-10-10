pipeline "attach_iam_role_policy" {
  title       = "Attach IAM Role Policy"
  description = "Attaches the specified managed policy to the specified IAM role. When you attach a managed policy to a role, the managed policy becomes part of the role's permission (access) policy."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
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
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "iam", "attach-role-policy",
      "--role-name", param.role_name,
      "--policy-arn", param.policy_arn,
    ]

    env = param.conn.env
  }
}
