pipeline "subscribe_to_sns" {
  title       = "Subscribe to SNS Topic"
  description = "Subscribes to a specified AWS SNS topic."

  param "region" {
    type        = string
    description = "The name of the region."
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = "The ID for this access key."
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = "The secret key used to sign requests."
    default     = var.secret_access_key
  }

  param "sns_topic_arn" {
    type        = string
    description = "The Amazon Resource Name (ARN) of the SNS topic to subscribe to."
    default     = "arn:aws:sns:us-east-1:533793682495:aws-cis-handling"
  }

  param "protocol" {
    type        = string
    description = "The protocol to use for the subscription (e.g., email, sms, lambda, etc.)."
    default     = "email"
  }

  param "endpoint" {
    type        = string
    description = "The endpoint that will receive notifications."
    default     = "priyanka.chatterjee@turbot.com"
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
