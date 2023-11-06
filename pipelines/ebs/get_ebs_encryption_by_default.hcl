pipeline "get_ebs_encryption_by_default" {
  title       = "Get EBS Encryption by Default"
  description = "Describes whether EBS encryption by default is enabled for your account in the current Region."

  param "region" {
    type        = string
    description = "The region to use."
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

  step "container" "get_ebs_encryption_by_default" {
    image = "amazon/aws-cli"

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
    description = "The standard output stream from the AWS CLI."
    value = jsondecode(step.container.get_ebs_encryption_by_default.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value = step.container.get_ebs_encryption_by_default.stderr
  }

}
