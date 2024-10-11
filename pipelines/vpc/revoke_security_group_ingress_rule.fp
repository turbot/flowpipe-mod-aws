pipeline "revoke_vpc_security_group_ingress" {
  title       = "Revoke VPC Security Group Ingress"
  description = "Removes the specified inbound (ingress) rules from a security group."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
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

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "delete_security_group_rule" {
    description = "Confirmation of security group removal"
    value       = jsondecode(step.container.delete_security_group_rule.stdout)
  }
}
