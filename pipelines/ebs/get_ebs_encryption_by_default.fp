pipeline "get_ebs_encryption_by_default" {
  title       = "Get EBS Encryption by Default"
  description = "Describes whether EBS encryption by default is enabled for your account in the current Region."

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

  step "container" "get_ebs_encryption_by_default" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "ec2", "get-ebs-encryption-by-default"
    ]
    env = {
      AWS_REGION            = var.region
      AWS_ACCESS_KEY_ID     = var.access_key_id
      AWS_SECRET_ACCESS_KEY = var.secret_access_key
    }
  }

  output "stdout" {
    description = "The AWS CLI output."
    value = jsondecode(step.container.get_ebs_encryption_by_default.stdout)
  }
}
