pipeline "create_iam_policy" {
  title       = "Create IAM Policy"
  description = "Creates a new policy for your Amazon Web Services account."

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

    env = {
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = jsondecode(step.container.create_iam_policy.stdout)
  }

   output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.create_iam_policy.stderr
  }
}
