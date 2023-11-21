pipeline "delete_s3_bucket" {
  title       = "Delete S3 Bucket"
  description = "Deletes an Amazon S3 bucket."

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
    description = "The name of the S3 bucket to delete."
  }

  step "container" "delete_s3_bucket" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "s3api",
      "delete-bucket",
      "--bucket", param.bucket
    ]

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.delete_s3_bucket.stderr
  }
}
