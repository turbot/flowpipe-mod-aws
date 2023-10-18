pipeline "list_users" {
  title       = "List Users"
  description = "Lists the IAM users."

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

  step "container" "list_users" {
    image = "amazon/aws-cli"
    cmd = [
      "iam", "list-users"
    ]

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "List of available users."
    value = jsondecode(step.container.list_users.stdout)
  }

  output "stderr" {
    value = step.container.list_users.stderr
  }
}
