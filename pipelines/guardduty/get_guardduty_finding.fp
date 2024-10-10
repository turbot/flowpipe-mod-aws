pipeline "get_guardduty_finding" {
  title       = "Get GuardDuty Finding"
  description = "Get details about a specific GuardDuty finding."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
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

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "findings" {
    description = "A list of findings."
    value       = jsondecode(step.container.get_guardduty_finding.stdout).Findings
  }
}
