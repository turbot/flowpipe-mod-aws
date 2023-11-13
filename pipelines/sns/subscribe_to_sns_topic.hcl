pipeline "subscribe_to_sns" {
  title       = "Subscribe to SNS Topic"
  description = "Subscribes to a specified AWS SNS topic."

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = local.access_key_id_param_description
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = local.secret_access_key_param_description
    default     = var.secret_access_key
  }

  param "sns_topic_arn" {
    type        = string
    description = "The Amazon Resource Name (ARN) of the SNS topic to subscribe to."
  }

  param "protocol" {
    type        = string
    description = "The protocol to use for the subscription (e.g., email, sms, lambda, etc.)."
  }

  param "endpoint" {
    type        = string
    description = "The endpoint that will receive notifications."
  }

  step "container" "subscribe_to_sns" {
    image = "amazon/aws-cli"

    cmd = ["sns", "subscribe",
      "--topic-arn", param.sns_topic_arn,
      "--protocol", param.protocol,
      "--notification-endpoint", param.endpoint // notification-endpoint is mandatory with protocols
    ]

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = jsondecode(step.container.subscribe_to_sns.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.subscribe_to_sns.stderr
  }
}