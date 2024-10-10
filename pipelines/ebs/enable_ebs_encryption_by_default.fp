pipeline "enable_ebs_encryption_by_default" {
  title       = "Enable EBS Encryption by Default"
  description = "Enables EBS encryption by default for your account in the current Region."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  step "container" "enable_ebs_encryption_by_default" {
    description = "Update the state of EBS default encryption."

    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "ec2", "enable-ebs-encryption-by-default"
    ]
    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "ebs_encryption_by_default" {
    description = "The updated state of EBS default encryption."
    value       = jsondecode(step.container.enable_ebs_encryption_by_default.stdout).EbsEncryptionByDefault
  }
}
