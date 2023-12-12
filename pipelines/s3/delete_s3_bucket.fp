pipeline "delete_s3_bucket" {
  title       = "Delete S3 Bucket"
  description = "Deletes an Amazon S3 bucket."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}
