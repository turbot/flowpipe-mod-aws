pipeline "get_lambda_function" {
  title       = "Get Lambda Function"
  description = "Retrieves details about an AWS Lambda function."

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
    description = "The name of the Lambda function to retrieve details for."
  }

  step "container" "get_lambda_function" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["lambda", "get-function"],
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
    value       = jsondecode(step.container.get_lambda_function.stdout)
  }
}
