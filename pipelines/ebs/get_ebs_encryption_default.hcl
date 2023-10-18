pipeline "get_ebs_encryption_default" {

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

  step "container" "get_encryption_defaults" {
    description = "Get EBS Default Encryption"
    # Call the AWS CLI
    image       = "amazon/aws-cli"
    cmd         = [
      "ec2", "get-ebs-encryption-by-default",
      "--region", "${ var.region }"
    ]
    env = {
      AWS_REGION            = var.region
      AWS_ACCESS_KEY_ID     = var.access_key_id
      AWS_SECRET_ACCESS_KEY = var.secret_access_key
    }
  }

  output "stdout" {
    value = jsondecode(step.container.get_encryption_defaults.stdout)
  }

  output "stderr" {
    value = step.container.get_encryption_defaults.stderr
  }

}