pipeline "create_lambda_function" {
  title       = "Create Lambda Function"
  description = "Creates an AWS Lambda function."

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
    description = "The name of the Lambda function."
  }

  param "role" {
    type        = string
    description = "The Amazon Resource Name (ARN) of the execution role that the function assumes."
  }

  param "code" {
    type        = string
    description = "The code for the Lambda function. It can be either a S3 bucket object with a specific key or a local file path."
    optional    = true
  }

  param "publish" {
    type        = bool
    description = "Publishes the Lambda function as a new version if set to true. Otherwise, it doesn't publish the function."
    optional    = true
  }

  step "container" "create_lambda_function" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["lambda", "create-function"],
      ["--function-name", param.function_name],
      ["--role", param.role],
      param.code ? ["--code", param.code] : [],
      param.publish ? ["--publish"] : [],
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The AWS CLI output."
    value       = jsondecode(step.container.create_lambda_function.stdout)
  }
}
