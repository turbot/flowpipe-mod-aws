pipeline "enable_ebs_encryption_by_default" {
  title       = "Enable EBS Encryption by Default"
  description = "Enables EBS encryption by default for your account in the current Region."

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

  step "container" "enable_ebs_encryption_by_default" {
    description = "Update the state of EBS default encryption."

    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd   = [
      "ec2", "enable-ebs-encryption-by-default"
    ]
    env = {
      AWS_REGION            = var.region
      AWS_ACCESS_KEY_ID     = var.access_key_id
      AWS_SECRET_ACCESS_KEY = var.secret_access_key
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value = jsondecode(step.container.enable_ebs_encryption_by_default.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value = step.container.enable_ebs_encryption_by_default.stderr
  }

}
