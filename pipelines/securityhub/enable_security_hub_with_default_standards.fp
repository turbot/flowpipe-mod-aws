pipeline "enable_security_hub_with_default_standards" {
  title       = "Enable Security Hub with Default Standards"
  description = "Enables AWS Security Hub and its default standards in the specified region."

  param "region" {
    type        = string
    description = "The AWS region where you want to enable Security Hub."
  }

  param "cred" {
    type        = string
    description = "The AWS credentials to use for authentication."
    default     = "default"
  }

  step "container" "enable_security_hub" {
    description = "Enables AWS Security Hub with default standards."

    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "securityhub", "enable-security-hub", "--enable-default-standards"
    ]
    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "security_hub_status" {
    description = "The status after enabling Security Hub with default standards."
    value       = step.container.enable_security_hub.stdout
  }
}
