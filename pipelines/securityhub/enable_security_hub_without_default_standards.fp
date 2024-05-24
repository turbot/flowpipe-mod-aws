pipeline "enable_security_hub_without_default_standards" {
  title       = "Enable Security Hub without Default Standards"
  description = "Enables AWS Security Hub without its default standards in the specified region."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  step "container" "enable_security_hub" {
    description = "Enables AWS Security Hub without default standards."

    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "securityhub", "enable-security-hub", "--no-enable-default-standards"
    ]
    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "security_hub_status" {
    description = "The status after enabling Security Hub without default standards."
    value       = step.container.enable_security_hub.stdout
  }
}
