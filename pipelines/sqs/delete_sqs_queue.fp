pipeline "delete_sqs_queue" {
  title       = "Delete SQS Queue"
  description = "Deletes an Amazon SQS queue."

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
    description = "The URL of the Amazon SQS queue to delete."
  }

  step "container" "delete_sqs_queue" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["sqs", "delete-queue"],
      ["--queue-url", param.queue_url],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }
}
