pipeline "test_get_lambda_function" {
  title       = "Test Get Lambda Function"
  description = "Tests the creation, retrieval, and deletion of a Lambda function"

  tags = {
    type = "test"
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "function_name" {
    default = "flowpipe-test-${uuid()}"
  }

  param "role_name" {
    default = "flowpipe-test-${uuid()}"
  }

  param "assume_role_policy_document" {
    type    = string
    default = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOT
  }

  # Create IAM role
  step "pipeline" "create_iam_role" {
    pipeline = pipeline.create_iam_role
    args = {
      conn                        = param.conn
      assume_role_policy_document = param.assume_role_policy_document
      role_name                   = param.role_name
    }
  }

  # Create Lambda function
  step "pipeline" "create_lambda_function" {
    if       = !is_error(step.pipeline.create_iam_role)
    pipeline = pipeline.create_lambda_function
    args = {
      conn          = param.conn
      region        = param.region
      function_name = param.function_name
      role          = step.pipeline.create_iam_role.output.role.Arn
    }
  }

  # Get Lambda function
  step "pipeline" "get_lambda_function" {
    if       = !is_error(step.pipeline.create_lambda_function)
    pipeline = pipeline.get_lambda_function
    args = {
      conn          = param.conn
      region        = param.region
      function_name = param.function_name
    }
  }

  # Delete Lambda function
  step "pipeline" "delete_lambda_function" {
    if       = !is_error(step.pipeline.create_lambda_function)
    pipeline = pipeline.delete_lambda_function
    args = {
      conn          = param.conn
      region        = param.region
      function_name = param.function_name
    }
  }

  # Delete IAM role
  step "pipeline" "delete_iam_role" {
    depends_on = [step.pipeline.delete_lambda_function]
    pipeline   = pipeline.delete_iam_role
    args = {
      conn      = param.conn
      region    = param.region
      role_name = param.role_name
    }
  }

  output "test_results" {
    value = {
      create_lambda_function = !is_error(step.pipeline.create_lambda_function) ? "pass" : "fail: ${error_message(step.pipeline.create_lambda_function)}"
      get_lambda_function    = !is_error(step.pipeline.get_lambda_function) ? "pass" : "fail: ${error_message(step.pipeline.get_lambda_function)}"
      delete_lambda_function = !is_error(step.pipeline.delete_lambda_function) ? "pass" : "fail: ${error_message(step.pipeline.delete_lambda_function)}"
    }
  }

}
