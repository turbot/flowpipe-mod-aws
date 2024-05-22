pipeline "delete_network_acl_entry" {
  title       = "Delete Network ACL Entry"
  description = "Deletes a specified entry from a network ACL."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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
    type        = boolean
    description = "Set to true to delete an egress rule, or false for an ingress rule."
    default     = true
  }

  step "container" "remove_acl_entry" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "ec2", "delete-network-acl-entry",
      "--network-acl-id", param.network_acl_id,
      "--rule-number", param.rule_number,
      param.is_egress ? "--egress" : "--ingress"
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "acl_entry_removal" {
    description = "Confirmation of network ACL entry removal."
    value       = "Network ACL entry with rule number ${param.rule_number} removed successfully."
  }
}
