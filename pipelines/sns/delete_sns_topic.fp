pipeline "delete_sns_topic" {
  title       = "Delete SNS Topic"
  description = "Deletes an Amazon SNS topic."

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
    description = "The Amazon Resource Name (ARN) of the Amazon SNS topic to delete."
  }

  step "container" "delete_sns_topic" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["sns", "delete-topic"],
      ["--topic-arn", param.topic_arn],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }
}
