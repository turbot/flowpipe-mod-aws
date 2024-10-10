pipeline "update_dynamodb_table" {
  title       = "Update DynamoDB Table"
  description = "Update settings for a DynamoDB Table."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "table_name" {
    type        = string
    description = "The name of the DynamoDB table to update."
  }

  step "container" "update_dynamodb_table" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["dynamodb", "update-table", "--table-name", param.table_name, "--deletion-protection-enabled"],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "table_name" {
    description = "Contains the details of a DynamoDB Table."
    value       = jsondecode(step.container.update_dynamodb_table.stdout).TableDescription
  }
}
