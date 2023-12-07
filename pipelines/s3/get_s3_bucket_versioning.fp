pipeline "get_s3_bucket_versioning" {
  title       = "Get S3 Bucket Versioning"
  description = "Get the versioning state of an S3 bucket."

  tags = {
    type = "featured"
  }

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "bucket" {
    type        = string
    description = "The bucket name."
  }

  step "container" "get_s3_bucket_versioning" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = ["s3api", "get-bucket-versioning", "--bucket", param.bucket]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "status" {
    description = "The versioning state of the bucket."
    value       = jsondecode(step.container.get_s3_bucket_versioning.stdout).Status
  }
}
