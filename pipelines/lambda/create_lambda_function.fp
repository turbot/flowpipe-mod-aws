pipeline "create_lambda_function" {
  title       = "Create Lambda Function"
  description = "Creates an AWS Lambda function."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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
    description = "The code for the function in shorthand syntax: S3Bucket=string,S3Key=string,S3ObjectVersion=string,ImageUri=string"
  }

  param "publish" {
    type        = bool
    description = "Publishes the Lambda function as a new version if set to true. Otherwise, it doesn't publish the function."
    optional    = true
  }

  step "container" "create_lambda_function" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["lambda", "create-function"],
      ["--function-name", param.function_name],
      ["--role", param.role],
      ["--code", param.code],
      param.publish ? ["--publish"] : [],
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "function" {
    description = "The Lambda function."
    value       = jsondecode(step.container.create_lambda_function.stdout)
  }
}
