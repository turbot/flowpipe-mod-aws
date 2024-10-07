pipeline "delete_s3_bucket_all_objects" {
  title       = "Delete S3 Bucket all Objects"
  description = "Deletes an Amazon S3 bucket all objects."

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
    description = "The name of the S3 bucket to delete objects."
  }

  step "container" "delete_s3_bucket_all_objects" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "s3",
      "rm",
      "s3://${param.bucket}"
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}
