pipeline "create_sns_topic" {
  title       = "Create SNS Topic"
  description = "Creates an Amazon SNS topic."

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

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = jsondecode(step.container.create_sns_topic.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.create_sns_topic.stderr
  }
}
