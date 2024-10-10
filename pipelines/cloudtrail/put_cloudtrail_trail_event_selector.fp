pipeline "put_cloudtrail_trail_event_selector" {
  title       = "Put event selectors to CloudTrail Trail"
  description = "Enables log file validation for an AWS CloudTrail trail."

  param "region" {
    type        = string
    description = "The AWS region where the CloudTrail trail is located."
  }

  param "cred" {
    type        = string
    description = "The AWS credentials to use."
    default     = "default"
  }

  param "trail_name" {
    type        = string
    description = "The name of the CloudTrail trail."
  }

   param "event_selectors" {
    type        = string
    description = "The JSON string format of the event selector policy."
  }

  step "container" "set_event_selectors" {
     image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      [
        "cloudtrail", "put-event-selectors",
        "--trail-name", param.trail_name,
        "--event-selectors", param.event_selectors
      ]
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "trail" {
    description = "The CloudTrail trail with event selectors set."
    value       = jsondecode(step.container.set_event_selectors.stdout)
  }
}
