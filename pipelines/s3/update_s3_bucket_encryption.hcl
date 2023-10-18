pipeline "update_s3_bucket_encryption" {
  title       = "Update S3 Bucket Encryption"
  description = "Configures encryption settings for an Amazon S3 bucket."

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

  param "bucket" {
    type        = string
    description = "The name of the S3 bucket."
  }

  param "server_side_encryption_configuration" {
    type        = string
    description = "Specifies the default server-side-encryption configuration. A JSON document that has been converted to a string."
  }

  step "container" "update_s3_bucket_encryption" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["s3api", "put-bucket-encryption"],
      ["--bucket", param.bucket],
      ["--server-side-encryption-configuration", param.server_side_encryption_configuration],
    )

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The JSON output from the AWS CLI."
    value       = jsondecode(step.container.update_s3_bucket_encryption.stdout)
  }

  output "stderr" {
    description = "The error output from the AWS CLI."
    value       = step.container.update_s3_bucket_encryption.stderr
  }
}
