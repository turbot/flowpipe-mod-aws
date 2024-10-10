pipeline "update_cloudtrail_trail" {
  title       = "Update Cloudtrail Trail"
  description = "Update the cloudtrail trail"

  param "region" {
    type        = string
    description = "The AWS region where the CloudTrail trail is located."
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "trail_name" {
    type        = string
    description = "The name of the CloudTrail trail."
  }

  param "s3_bucket_name" {
    type        = string
    description = "The name of the S3 Bucket."
    optional    = true
  }

  param "enable_log_file_validation" {
    type        = bool
    description = "Enable the log file validation for CloudTrail trail."
    default     = false
  }

  param "cloudwatch_logs_log_group_arn" {
    type        = string
    description = "The ARN of the Cloudwatch Logs LogGroup"
    optional    = true
  }

  param "cloudwatch_logs_role_arn" {
    type        = string
    description = "The ARN of the IAM role for Cloudwatch Logs."
    optional    = true
  }

  param "kms_key_id" {
    type        = string
    description = "The KMS key ID for the trail."
    optional    = true
  }

  step "container" "update_cloudtrail_trail" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["cloudtrail", "update-trail",
      "--name", param.trail_name],
      param.enable_log_file_validation != false ? ["--enable-log-file-validation"] : [],
      param.cloudwatch_logs_log_group_arn != null ? ["--cloud-watch-logs-log-group-arn", param.cloudwatch_logs_log_group_arn] : [],
      param.cloudwatch_logs_role_arn != null ?
      ["--cloud-watch-logs-role-arn", param.cloudwatch_logs_role_arn] : [],
      param.s3_bucket_name != null ?
      ["--s3-bucket-name", param.s3_bucket_name] : [],
      param.kms_key_id != null ? ["--kms-key-id", param.kms_key_id] : []
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "trail" {
    description = "The updated CloudTrail trail."
    value       = jsondecode(step.container.update_cloudtrail_trail.stdout)
  }
}
