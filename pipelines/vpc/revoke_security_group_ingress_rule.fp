pipeline "revoke_security_group_ingress_rule" {
  title       = "Delete security group ingress rule."
  description = "Delete a security group ingress rule from an existing security group."

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

  param "security_group_id" {
    type        = string
    description = "The ID of the security group."
  }

  param "security_group_rule_id" {
    type        = string
    description = "The ID of the security group rule."
  }

  step "container" "delete_security_group_rule" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "ec2", "revoke-security-group-ingress",
      "--group-id", param.security_group_id,
      "--security-group-rule-ids", param.security_group_rule_id
    ]

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }
}
