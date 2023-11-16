pipeline "list_guardduty_findings" {
  title       = "List GuardDuty Findings"
  description = "List Amazon GuardDuty findings for a specified detector."

  param "region" {
    type        = string
    description = "The name of the region."
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

  param "detector_id" {
    type        = string
    description = "The ID of the GuardDuty detector."
  }

  step "container" "list_guardduty_findings" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["guardduty", "list-findings"],
      ["--detector-id", param.detector_id],
    )

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = jsondecode(step.container.list_guardduty_findings.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.list_guardduty_findings.stderr
  }
}