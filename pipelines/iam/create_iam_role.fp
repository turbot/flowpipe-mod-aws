pipeline "create_iam_role" {
  title       = "Create IAM Role"
  description = "Creates a new role for your Amazon Web Services account."

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
    description = "The name of the role to create. Must be unique within the account."
  }

  param "assume_role_policy_document" {
    type        = string
    description = "The trust relationship policy document that grants an entity permission to assume the role. A JSON policy that has been converted to a string."
  }

  step "container" "create_iam_role" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "iam", "create-role",
      "--role-name", param.role_name,
      "--assume-role-policy-document", param.assume_role_policy_document,
    ]

    env = {
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "role" {
    description = "A structure containing details about the new role."
    value       = jsondecode(step.container.create_iam_role.stdout)
  }
}
