pipeline "set_sqs_queue_attributes" {
  title       = "Set SQS Queue Attributes"
  description = "Sets attributes of an Amazon SQS queue."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "queue_url" {
    type        = string
    description = "The URL of the Amazon SQS queue to set attributes for."
  }

  param "attributes" {
    type        = string
    description = "A map of attributes to set."
  }

  step "container" "set_sqs_queue_attributes" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["sqs", "set-queue-attributes"],
      ["--queue-url", param.queue_url],
      ["--attributes", param.attributes],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }
}
