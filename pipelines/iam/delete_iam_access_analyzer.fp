pipeline "delete_iam_access_analyzer" {
  title       = "Delete IAM Access Analyzer"
  description = "Deletes an IAM Access Analyzer for your account."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "analyzer_name" {
    type        = string
    description = "The name of the Access Analyzer to delete."
  }

  step "container" "delete_analyzer" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["accessanalyzer", "delete-analyzer"],
      ["--analyzer-name", param.analyzer_name],
      ["--region", param.region]
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "result" {
    description = "Confirmation message that the IAM Access Analyzer has been deleted."
    value       = "Access Analyzer ${param.analyzer_name} in region ${param.region} has been deleted."
  }
}
