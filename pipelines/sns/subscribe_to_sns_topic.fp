pipeline "subscribe_to_sns_topic" {
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

  step "container" "subscribe_to_sns_topic" {
    image = "amazon/aws-cli"

    cmd = ["sns", "subscribe",
      "--topic-arn", param.sns_topic_arn,
      "--protocol", param.protocol,
      # notification-endpoint is mandatory with protocols
      "--notification-endpoint", param.endpoint,
    ]

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "subscription_arn" {
    description = "The ARN of the subscription if it is confirmed, or the string 'pending confirmation' if the subscription requires confirmation."
    value       = step.container.subscribe_to_sns_topic.stdout
  }
}
