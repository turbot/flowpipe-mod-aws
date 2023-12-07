pipeline "list_iam_users" {
  title       = "List IAM Users"
  description = "Lists the IAM users that have the specified path prefix. If no path prefix is specified, the operation returns all users in the Amazon Web Services account."

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "path_prefix" {
    type        = string
    description = "The path prefix for filtering the results. For example: /division_abc/subdivision_xyz/ , which would get all user names whose path starts with /division_abc/subdivision_xyz/ ."
    optional    = true
  }

  step "container" "list_iam_users" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["iam", "list-users"],
      param.path_prefix != null ? ["--path-prefix", "${param.path_prefix}"] : []
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "users" {
    description = "A list of users."
    value       = jsondecode(step.container.list_iam_users.stdout)
  }
}
