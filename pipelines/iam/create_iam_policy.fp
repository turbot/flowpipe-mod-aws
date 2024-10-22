pipeline "create_iam_policy" {
  title       = "Create IAM Policy"
  description = "Creates a new policy for your Amazon Web Services account."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "policy_name" {
    type        = string
    description = "The friendly name of the policy."
  }

  param "policy_document" {
    type        = string
    description = "The trust relationship policy document that grants an entity policy to assume the policy. A JSON policy that has been converted to a string."
  }

  step "container" "create_iam_policy" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "iam", "create-policy",
      "--policy-name", param.policy_name,
      "--policy-document", param.policy_document,
    ]

    env = param.conn.env
  }

  output "policy" {
    description = "A structure containing details about the new policy."
    value       = jsondecode(step.container.create_iam_policy.stdout).Policy
  }
}
