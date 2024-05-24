pipeline "enable_security_hub" {
  title       = "Enable Security Hub"
  description = "Enables AWS Security Hub."

  param "region" {
    type        = string
    description = "The AWS region where you want to enable Security Hub."
  }

  param "cred" {
    type        = string
    description = "The AWS credentials to use for authentication."
    default     = "default"
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
    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "security_hub_status" {
    description = "The status after enabling Security Hub with default standards."
    value       = step.container.enable_security_hub.stdout
  }
}