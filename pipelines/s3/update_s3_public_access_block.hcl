pipeline "update_s3_public_access_block" {
  title       = "Update S3 Public Access Block"
  description = "Configures public access settings for an Amazon S3 bucket."

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

  param "public_access_block_configuration" {
    type        = string
    description = "A JSON string containing the public access block settings for the bucket."
  }

  step "container" "update_s3_public_access_block" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["s3api", "put-public-access-block"],
      ["--bucket", param.bucket],
      ["--public-access-block-configuration", param.public_access_block_configuration]
    )

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The JSON output from the AWS CLI."
    value       = jsondecode(step.container.update_s3_public_access_block.stdout)
  }

  output "stderr" {
    description = "The error output from the AWS CLI."
    value       = step.container.update_s3_public_access_block.stderr
  }
}
