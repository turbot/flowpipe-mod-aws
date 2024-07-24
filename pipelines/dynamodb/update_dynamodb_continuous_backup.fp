pipeline "update_dynamodb_continuous_backup" {
  title       = "Update DynamoDB Table Continuous Backup"
  description = "Update settings for a DynamoDB Table Continuous Backup."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "table_name" {
    type        = string
    description = "The name of the DynamoDB table to update."
  }

  step "container" "update_dynamodb_continuous_backup" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "dynamodb", "update-continuous-backups", "--table-name", param.table_name, "--point-in-time-recovery-specification",  "PointInTimeRecoveryEnabled=true",
      ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "continuous_backups_description" {
    description = "Contains the details of a DynamoDB Table Continuous Backup."
    value       = jsondecode(step.container.update_dynamodb_continuous_backup.stdout).ContinuousBackupsDescription
  }
}
