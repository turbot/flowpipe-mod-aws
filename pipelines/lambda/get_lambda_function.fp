pipeline "get_lambda_function" {
  title       = "Get Lambda Function"
  description = "Retrieves details about an AWS Lambda function."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "function_name" {
    type        = string
    description = "The name of the Lambda function to retrieve details for."
  }

  step "container" "get_lambda_function" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["lambda", "get-function"],
      ["--function-name", param.function_name],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "function" {
    description = "The configuration of the Lambda function."
    value       = jsondecode(step.container.get_lambda_function.stdout)
  }
}
