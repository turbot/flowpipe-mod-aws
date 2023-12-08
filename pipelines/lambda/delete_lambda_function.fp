pipeline "delete_lambda_function" {
  title       = "Delete Lambda Function"
  description = "Deletes an AWS Lambda function."

  tags = {
    type = "featured"
  }

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

  param "function_name" {
    type        = string
    description = "The name of the Lambda function to delete."
  }

  step "container" "delete_lambda_function" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["lambda", "delete-function"],
      ["--function-name", param.function_name],
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}
