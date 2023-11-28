pipeline "create_findings_report" {
  title       = "Create Findings Report"
  description = "Generates a findings report based on specified criteria and saves it to the specified S3 bucket."

  param "region" {
    type        = string
    description = "The name of the Region."
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = "The ID for this access key."
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = "The secret key used to sign requests."
    default     = var.secret_access_key
  }

  param "filter_criteria" {
    type        = string
    description = "Filter criteria for generating the findings report."
    optional    = true
  }

  param "report_format" {
    type        = string
    description = "The format for the findings report. e.g., PDF, CSV, JSON, etc."
    default     = "JSON"
  }

  param "s3_bucket_name" {
    type        = string
    description = "The name of the Amazon S3 bucket to export findings to."
  }

  param "s3_key_prefix" {
    type        = string
    description = "The prefix of the KMS key used to export findings."
  }

  param "s3_kms_key_arn" {
    type        = string
    description = "The ARN of the KMS key used to encrypt data when exporting findings."
  }

  step "container" "create_findings_report" {
    image = "amazon/aws-cli"

    cmd = [
      "inspector2 ",
      "create-findings-report",
      "--region", "param.region",
      param.filter_criteria != null ? ["--filter-criteria", "param.filter_criteria"] : [],
      "--report-format", param.report_format,
      "--s3-destination", "bucketName=${param.s3_bucket_name},keyPrefix=${param.s3_key_prefix},kmsKeyArn=${param.s3_kms_key_arn}",
    ]

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "Details of the generated findings report."
    value       = jsondecode(step.container.create_findings_report.stdout)
  }

  output "stderr" {
    value = step.container.create_findings_report.stderr
  }
}
