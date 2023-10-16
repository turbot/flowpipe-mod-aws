pipeline "delete_lambda_function" {
  title       = "Delete Lambda Function"
  description = "Deletes an AWS Lambda function."

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

  param "function_name" {
    type        = string
    description = "The name of the Lambda function to delete."
  }

  step "container" "delete_lambda_function" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["lambda", "delete-function"],
      ["--function-name", param.function_name],
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = step.container.delete_lambda_function.stdout
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.delete_lambda_function.stderr
  }
}
