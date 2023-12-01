pipeline "create_sns_topic" {
  title       = "Create SNS Topic"
  description = "Creates an Amazon SNS topic."

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

  param "name" {
    type        = string
    description = "The name of the Amazon SNS topic to create."
  }

  step "container" "create_sns_topic" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["sns", "create-topic"],
      ["--name", param.name],
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "topic_arn" {
    description = "The Amazon Resource Name (ARN) assigned to the created topic."
    value       = step.container.create_sns_topic.stdout
  }
}
