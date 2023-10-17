pipeline "update_s3_bucket_versioning" {
  title       = "Update S3 Bucket Versioning"
  description = "Sets the versioning state of an existing bucket."

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

  param "name" {
    type        = string
    description = "The bucket name."
  }

  param "versioning" {
    type        = bool
    description = "The versioning state of the bucket."
  }

  step "container" "update_s3_bucket_versioning" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["s3api", "put-bucket-versioning", "--bucket", param.name, "--versioning-configuration"],
      param.versioning ? ["Status=Enabled"] : ["Status=Suspended"],
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    value = step.container.update_s3_bucket_versioning.stdout
  }

  output "stderr" {
    value = step.container.update_s3_bucket_versioning.stderr
  }
}
