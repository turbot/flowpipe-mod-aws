pipeline "enable_ebs_encryption_by_default {
  title       = "Enable EBS Default Encryption"
  description = "Enable EBS Default Encryption in a specific region."

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

  step "container" "enable_encryption_defaults" {
    description = "Update the state of EBS default encryption."

    image = "amazon/aws-cli"
    cmd         = [
      "ec2", "enable-ebs-encryption-by-default",
      "--region", "${ var.region }"
    ]
    env = {
      AWS_REGION            = var.region
      AWS_ACCESS_KEY_ID     = var.access_key_id
      AWS_SECRET_ACCESS_KEY = var.secret_access_key
    }
  }

  output "stdout" {
    value = jsondecode(step.container.enable_encryption_defaults.stdout)
  }

  output "stderr" {
    value = step.container.enable_encryption_defaults.stderr
  }

}