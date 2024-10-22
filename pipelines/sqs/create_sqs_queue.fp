pipeline "create_sqs_queue" {
  title       = "Create SQS Queue"
  description = "Creates an Amazon SQS queue."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "queue_name" {
    type        = string
    description = "The name of the Amazon SQS queue to create."
  }

  step "container" "create_sqs_queue" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["sqs", "create-queue"],
      ["--queue-name", param.queue_name],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "queue_url" {
    description = "The URL of the Amazon SQS queue."
    value       = jsondecode(step.container.create_sqs_queue.stdout).QueueUrl
  }
}
