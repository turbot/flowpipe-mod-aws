pipeline "subscribe_to_sns_topic" {
  title       = "Subscribe to SNS Topic"
  description = "Subscribes to a specified AWS SNS topic."

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = ["sns", "subscribe",
      "--topic-arn", param.sns_topic_arn,
      "--protocol", param.protocol,
      # notification-endpoint is mandatory with protocols
      "--notification-endpoint", param.endpoint,
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "subscription_arn" {
    description = "The ARN of the subscription if it is confirmed, or the string 'pending confirmation' if the subscription requires confirmation."
    value       = step.container.subscribe_to_sns_topic.stdout
  }
}
