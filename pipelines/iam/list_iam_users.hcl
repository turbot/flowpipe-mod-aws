pipeline "list_iam_users" {
  title       = "List IAM Users"
  description = "Lists the IAM users that have the specified path prefix. If no path prefix is specified, the operation returns all users in the Amazon Web Services account."

  param "region" {
    type        = string
    description = "The name of the Region."
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = "The ID for this access key."
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = "The secret key used to sign requests."
    default     = var.secret_access_key
  }

  param "path_prefix" {
    type        = string
    description = "The path prefix for filtering the results. For example: /division_abc/subdivision_xyz/ , which would get all user names whose path starts with /division_abc/subdivision_xyz/ ."
    optional    = true
  }

  step "container" "list_iam_users" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["iam", "list-users"],
      param.path_prefix != null ? ["--path-prefix", "${param.path_prefix}"] : []
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "List of available users."
    value       = jsondecode(step.container.list_iam_users.stdout)
  }

  output "stderr" {
    value = step.container.list_iam_users.stderr
  }
}
