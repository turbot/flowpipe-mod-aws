pipeline "delete_sns_topic" {
  title       = "Delete SNS Topic"
  description = "Deletes an Amazon SNS topic."

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
    description = "The Amazon Resource Name (ARN) of the Amazon SNS topic to delete."
  }

  step "container" "delete_sns_topic" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["sns", "delete-topic"],
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
    value       = step.container.delete_sns_topic.stdout
  }
}
