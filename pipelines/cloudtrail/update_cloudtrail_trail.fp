pipeline "update_cloudtrail_trail" {
  title       = "Update Cloudtrail Trail"
  description = "Update the cloudtrail trail"

  tags = {
    type = "featured"
  }

  param "region" {
    type        = string
    description = "The AWS region where the CloudTrail trail is located."
  }

  param "cred" {
    type        = string
    description = "The AWS credentials to use."
    default     = "default"
  }

  param "trail_name" {
    type        = string
    description = "The name of the CloudTrail trail."
  }

  param "enable_log_file_validation" {
    type        = bool
    description = "Enable the log file validation for CloudTrail trail."
    default     = false
  }

  param "cloudwatch_logs_log_group_arn" {
    type        = string
    description = "The ARN of the Cloudwatch Logs LogGroup"
  }

  param "cloudwatch_logs_role_arn" {
    type        = string
    description = "The ARN of the IAM role for Cloudwatch Logs."
  }

  step "container" "update_cloudtrail_trail" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["cloudtrail", "update-trail",
      "--name", param.trail_name],
      param.enable_log_file_validation != false ? ["--enable-log-file-validation"] : [],
      param.cloudwatch_logs_log_group_arn != null ? ["--cloud-watch-logs-log-group-arn", param.cloudwatch_logs_log_group_arn] : [],
      param.cloudwatch_logs_role_arn != null ?
      ["--cloud-watch-logs-role-arn", param.cloudwatch_logs_role_arn] : []
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "trail" {
    description = "The CloudTrail trail with log file validation enabled."
    value       = jsondecode(step.container.update_cloudtrail_trail.stdout)
  }
}