pipeline "get_findings_report_status" {
  title       = "Get Findings Report Status"
  description = "Get the status of a findings report generation."

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

  param "report_id" {
    type        = string
    description = "The ID of the report to retrieve."
    optional    = true
  }

  step "container" "get_findings_report_status" {
    image = "amazon/aws-cli"

    cmd = [
      "inspector2 ",
      "get-findings-report-status",
      "--region", "param.region",
      "--report-id", param.report_id,
    ]

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "Details of the findings report."
    value       = jsondecode(step.container.get_findings_report_status.stdout)
  }

  output "stderr" {
    value = step.container.get_findings_report_status.stderr
  }
}
