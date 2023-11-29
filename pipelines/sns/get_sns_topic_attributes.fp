pipeline "get_sns_topic_attributes" {
  title       = "Get SNS Topic Attributes"
  description = "Retrieves attributes of an Amazon SNS topic."

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

  param "topic_arn" {
    type        = string
    description = "The Amazon Resource Name (ARN) of the Amazon SNS topic."
  }

  step "container" "get_sns_topic_attributes" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["sns", "get-topic-attributes"],
      ["--topic-arn", param.topic_arn],
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The AWS CLI output."
    value       = jsondecode(step.container.get_sns_topic_attributes.stdout)
  }
}
