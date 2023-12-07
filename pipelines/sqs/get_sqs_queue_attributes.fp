pipeline "get_sqs_queue_attributes" {
  title       = "Get SQS Queue Attributes"
  description = "Retrieves attributes of an Amazon SQS queue."

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "queue_url" {
    type        = string
    description = "The URL of the Amazon SQS queue to retrieve attributes for."
  }

  step "container" "get_sqs_queue_attributes" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["sqs", "get-queue-attributes"],
      ["--attribute-names", "All"],
      ["--queue-url", param.queue_url],
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "attributes" {
    description = "A map of attributes to their respective values."
    value       = jsondecode(step.container.get_sqs_queue_attributes.stdout).Attributes
  }
}
