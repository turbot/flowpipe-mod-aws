pipeline "get_sns_topic_attributes" {
  title       = "Get SNS Topic Attributes"
  description = "Retrieves attributes of an Amazon SNS topic."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "topic_arn" {
    type        = string
    description = "The Amazon Resource Name (ARN) of the Amazon SNS topic."
  }

  step "container" "get_sns_topic_attributes" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["sns", "get-topic-attributes"],
      ["--topic-arn", param.topic_arn],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "attributes" {
    description = "A map of the topic’s attributes."
    value       = jsondecode(step.container.get_sns_topic_attributes.stdout).Attributes
  }
}
