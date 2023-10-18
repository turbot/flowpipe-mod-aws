pipeline "get_s3_bucket_versioning" {
  title       = "Get S3 Bucket Versioning"
  description = "Get the versioning state of an S3 bucket."

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
    description = "The bucket name."
  }

  step "container" "get_s3_bucket_versioning" {
    image = "amazon/aws-cli"

    cmd = ["s3api", "get-bucket-versioning", "--bucket", param.bucket]

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The JSON output from the AWS CLI."
    value       = jsondecode(step.container.get_s3_bucket_versioning.stdout)
  }

  output "stderr" {
    description = "The error output from the AWS CLI."
    value       = step.container.get_s3_bucket_versioning.stderr
  }
}
