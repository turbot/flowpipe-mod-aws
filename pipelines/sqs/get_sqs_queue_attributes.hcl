pipeline "get_sqs_queue_attributes" {
  title       = "Get SQS Queue Attributes"
  description = "Retrieves attributes of an Amazon SQS queue."

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

  param "queue_url" {
    type        = string
    description = "The URL of the Amazon SQS queue to retrieve attributes for."
  }

  step "container" "get_sqs_queue_attributes" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["sqs", "get-queue-attributes"],
      ["--queue-url", param.queue_url],
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = jsondecode(step.container.get_sqs_queue_attributes.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.get_sqs_queue_attributes.stderr
  }
}
