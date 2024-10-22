pipeline "list_guardduty_findings" {
  title       = "List GuardDuty Findings"
  description = "List Amazon GuardDuty findings for a specified detector."

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

  step "container" "list_guardduty_findings" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["guardduty", "list-findings"],
      ["--detector-id", param.detector_id],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "finding_ids" {
    description = "The IDs of the findings that you're listing."
    value       = jsondecode(step.container.list_guardduty_findings.stdout).FindingIds
  }
}
