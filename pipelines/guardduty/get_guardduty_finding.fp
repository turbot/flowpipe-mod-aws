pipeline "get_guardduty_finding" {
  title       = "Get GuardDuty Finding"
  description = "Get details about a specific GuardDuty finding."

  tags = {
    type = "featured"
  }

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["guardduty", "get-findings"],
      ["--detector-id", param.detector_id],
      ["--finding-id"], param.finding_id,
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "findings" {
    description = "A list of findings."
    value       = jsondecode(step.container.get_guardduty_finding.stdout).Findings
  }
}
