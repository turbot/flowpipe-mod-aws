pipeline "update_s3_bucket_encryption" {
  title       = "Update S3 Bucket Encryption"
  description = "Configures encryption settings for an Amazon S3 bucket."

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

  param "bucket" {
    type        = string
    description = "The name of the S3 bucket."
  }

  param "server_side_encryption_configuration" {
    type        = string
    description = "Specifies the default server-side-encryption configuration. A JSON document that has been converted to a string."
  }

  step "container" "update_s3_bucket_encryption" {
    image = "public.ecr.aws/aws-cli/aws-cli"

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
    description = "The standard output stream from the AWS CLI."
    value       = jsondecode(step.container.update_s3_bucket_encryption.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.update_s3_bucket_encryption.stderr
  }
}
