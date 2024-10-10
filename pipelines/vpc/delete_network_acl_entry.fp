pipeline "delete_network_acl_entry" {
  title       = "Delete Network ACL Entry"
  description = "Deletes a specified entry from a network ACL."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "network_acl_id" {
    type        = string
    description = "The ID of the network ACL from which to delete the entry."
  }

  param "rule_number" {
    type        = number
    description = "The rule number of the entry to delete."
  }

  param "is_egress" {
    type        = bool
    description = "Set to true to delete an egress rule, or false for an ingress rule."
    default     = true
  }

  step "container" "remove_acl_entry" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat([
      "ec2", "delete-network-acl-entry",
      "--network-acl-id", param.network_acl_id,
      "--rule-number", format("%d", param.rule_number)
    ],
    param.is_egress != null ? ["--egress"] : ["--ingress"]
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "acl_entry_removal" {
    description = "Confirmation of network ACL entry removal."
    value       = "Network ACL entry with rule number ${param.rule_number} removed successfully."
  }
}
