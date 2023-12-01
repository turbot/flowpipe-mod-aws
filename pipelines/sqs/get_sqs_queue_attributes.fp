pipeline "get_sqs_queue_attributes" {
  title       = "Get SQS Queue Attributes"
  description = "Retrieves attributes of an Amazon SQS queue."

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

  output "attributes" {
    description = "A map of attributes to their respective values."
    value       = jsondecode(step.container.get_sqs_queue_attributes.stdout)
  }
}
