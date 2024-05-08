pipeline "update_route53_record" {
  title       = "Update Route 53 Record"
  description = "Updates a specified DNS record in Amazon Route 53."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "hosted_zone_id" {
    type        = string
    description = "The ID of the hosted zone containing the record."
  }

  param "record_name" {
    type        = string
    description = "The DNS name of the record to update."
  }

  param "record_type" {
    type        = string
    description = "The type of the DNS record (e.g., A, CNAME, MX, etc.)."
  }

  param "record_ttl" {
    type        = number
    description = "The TTL (time to live) of the DNS record."
  }

  param "record_values" {
    type        = list(string)
    description = "The new values of the DNS record."
  }

  step "container" "update_route53_record" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["route53", "change-resource-record-sets"],
      ["--hosted-zone-id", param.hosted_zone_id],
      ["--change-batch", jsonencode({
        Comment = "Update DNS record",
        Changes = [
          {
            Action = "UPSERT",
            ResourceRecordSet = {
              Name            = param.record_name,
              Type            = param.record_type,
              TTL             = param.record_ttl,
              ResourceRecords = [for value in param.record_values : { Value = value }]
            }
          }
        ]
      })]
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "change_info" {
    description = "Contains the details of an Amazon Route53 record update request."
    value       = jsondecode(step.container.update_route53_record.stdout).ChangeInfo
  }
}
