pipeline "enable_security_hub" {
  title       = "Enable Security Hub"
  description = "Enables AWS Security Hub."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "enable_default_standards" {
    type        = bool
    description = "Whether to enable the default standards."
  }

  step "container" "enable_security_hub" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = concat(
      ["securityhub", "enable-security-hub"],
      param.enable_default_standards ? ["--enable-default-standards"] : ["--no-enable-default-standards"]
    )
    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "security_hub_status" {
    description = "The status after enabling Security Hub."
    value       = step.container.enable_security_hub.stdout
  }
}
