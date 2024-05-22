pipeline "enable_cloudtrail_tail_log_file_validation" {
  title       = "Enable CloudTrail Log File Validation"
  description = "Enables log file validation for an AWS CloudTrail trail."

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

  step "container" "enable_log_file_validation" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "cloudtrail", "update-trail",
      "--name", param.trail_name,
      "--enable-log-file-validation"
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "trail" {
    description = "The CloudTrail trail with log file validation enabled."
    value       = jsondecode(step.container.enable_log_file_validation.stdout)
  }
}
