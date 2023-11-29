pipeline "get_guardduty_finding" {
  title       = "Get GuardDuty Finding"
  description = "Get details about a specific GuardDuty finding."

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = local.access_key_id_param_description
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = local.secret_access_key_param_description
    default     = var.secret_access_key
  }

  param "detector_id" {
    type        = string
    description = "The ID of the GuardDuty detector."
  }

  param "finding_id" {
    type        = list(string)
    description = "The IDs of the GuardDuty finding to retrieve details for."
  }

  step "container" "get_guardduty_finding" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["guardduty", "get-findings"],
      ["--detector-id", param.detector_id],
      ["--finding-id"], param.finding_id,
    )

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = jsondecode(step.container.get_guardduty_finding.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.get_guardduty_finding.stderr
  }
}