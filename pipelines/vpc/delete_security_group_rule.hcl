pipeline "delete_security_group_rule" {
  title       = "Delete security group."
  description = "Delete a security group rule."

  param "region" {
    type        = string
    description = "The name of the Region."
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = "The ID for this access key."
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = "The secret key used to sign requests."
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
    image = "amazon/aws-cli"

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

  output "stdout" {
    value = step.container.delete_security_group_rule.stdout
  }

  output "stderr" {
    value = step.container.delete_security_group_rule.stderr
  }
}