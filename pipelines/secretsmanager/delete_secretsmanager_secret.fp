pipeline "delete_secretsmanager_secret" {
  title       = "Delete Secrets Manager Secret"
  description = "Deletes an AWS Secrets Manager secret."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "secret_id" {
    type        = string
    description = "The ARN or name of the secret to delete."
  }

  step "container" "delete_secretsmanager_secret" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "secretsmanager", "delete-secret",
      "--secret-id", param.secret_id,
      "--force-delete-without-recovery"
    ]

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "secretsmanager_secret" {
    description = "Information about the deleted Secrets Manager secret."
    value       = jsondecode(step.container.delete_secretsmanager_secret.stdout)
  }
}