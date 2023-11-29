pipeline "delete_lambda_function" {
  title       = "Delete Lambda Function"
  description = "Deletes an AWS Lambda function."

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
    description = "The AWS CLI output."
    value       = step.container.delete_lambda_function.stdout
  }
}
