pipeline "update_s3_bucket_versioning" {
  title       = "Update S3 Bucket Versioning"
  description = "Sets the versioning state of an existing bucket."

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
    description = "The bucket name."
  }

  param "versioning" {
    type        = bool
    description = "The versioning state of the bucket."
  }

  step "container" "update_s3_bucket_versioning" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["s3api", "put-bucket-versioning", "--bucket", param.bucket, "--versioning-configuration"],
      param.versioning ? ["Status=Enabled"] : ["Status=Suspended"],
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.update_s3_bucket_versioning.stderr
  }
}
