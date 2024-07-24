pipeline "create_cloudwatch_log_group" {
  title       = "Create CloudWatch Log Group"
  description = "Creates a new CloudWatch log group."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "log_group_name" {
    type        = string
    description = "The name of the CloudWatch log group to be created."
  }

  param "retention_days" {
    type        = number
    description = "The retention period in days for the log group."
    optional    = true
    default     = 0
  }

  step "container" "create_log_group" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      [
        "logs", "create-log-group",
        "--log-group-name", param.log_group_name
      ],
      param.retention_days != 0 ? [
        "logs", "put-retention-policy",
        "--log-group-name", param.log_group_name,
        "--retention-in-days", param.retention_days
      ] : []
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "log_group_creation" {
    description = "Confirmation of the CloudWatch log group creation."
    value       = "Log group ${param.log_group_name} created successfully."
  }
}
