pipeline "list_guardduty_findings" {
  title       = "List GuardDuty Findings"
  description = "List Amazon GuardDuty findings for a specified detector."

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

  step "container" "list_guardduty_findings" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["guardduty", "list-findings"],
      ["--detector-id", param.detector_id],
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
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
