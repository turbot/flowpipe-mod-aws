pipeline "put_cloudtrail_trail_event_selectors_to_read_write_all" {
  title       = "Put event selectors to CloudTrail Trail"
  description = "Enables log file validation for an AWS CloudTrail trail."

  tags = {
    type = "featured"
  }

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

  step "container" "set_event_selectors" {
     image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      [
        "cloudtrail", "put-event-selectors",
        "--trail-name", param.trail_name,
        "--event-selectors", jsonencode([{
          "ReadWriteType": "All",
          "IncludeManagementEvents": true
        }])
      ]
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "trail" {
    description = "The CloudTrail trail with event selectors set."
    value       = jsondecode(step.container.set_event_selectors.stdout)
  }
}
