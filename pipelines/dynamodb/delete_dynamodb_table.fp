pipeline "delete_dynamodb_table" {
  title       = "Delete DynamoDB Table"
  description = "Deletes an Amazon DynamoDB table."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "aws_profile"
  }

  param "table_name" {
    type        = string
    description = "The name of the DynamoDB table to delete."
  }

  step "container" "delete_dynamodb_table" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "dynamodb", "delete-table",
      "--table-name", param.table_name
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}
