pipeline "create_cloudwatch_log_stream" {
  title       = "Create CloudWatch Log Stream"
  description = "Creates a new CloudWatch log stream within a specified log group."

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
    description = "The name of the CloudWatch log group in which the log stream will be created."
  }

  param "log_stream_name" {
    type        = string
    description = "The name of the CloudWatch log stream to be created."
  }

  step "container" "create_log_stream" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "logs", "create-log-stream",
      "--log-group-name", param.log_group_name,
      "--log-stream-name", param.log_stream_name
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "log_stream_creation" {
    description = "Confirmation of the CloudWatch log stream creation."
    value       = "Log stream ${param.log_stream_name} created successfully in log group ${param.log_group_name}."
  }
}
