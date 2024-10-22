pipeline "create_iam_access_analyzer" {
  title       = "Create IAM Access Analyzer"
  description = "Creates an IAM Access Analyzer for your account."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "analyzer_name" {
    type        = string
    description = "The name of the Access Analyzer to create."
  }

  param "analyzer_type" {
    type        = string
    description = "The type of analyzer to create. Valid values: ACCOUNT | ORGANIZATION."
    default     = "ACCOUNT"
  }

  step "container" "create_analyzer" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["accessanalyzer", "create-analyzer"],
      ["--analyzer-name", param.analyzer_name],
      ["--type", param.analyzer_type],
      ["--region", param.region]
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "analyzer" {
    description = "Contains the details of the created IAM Access Analyzer."
    value       = jsondecode(step.container.create_analyzer.stdout)
  }
}
