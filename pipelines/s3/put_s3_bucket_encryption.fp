pipeline "put_s3_bucket_encryption" {
  title       = "Put S3 Bucket Encryption"
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

  # TODO: AWS defaults to disabling default encryption if this isn't specified,
  # but we require it to prevent accidentally disabling encryption. Should it be required?
  param "sse_algorithm" {
    type        = string
    description = "Server-side encryption algorithm to use for the default encryption."
  }

  param "kms_master_key_id" {
    type        = string
    description = "Amazon Web Services Key Management Service (KMS) customer Amazon Web Services KMS key ID to use for the default encryption."
    optional    = true
  }

  # TODO: AWS defaults to false for this setting if not specified,
  # but we require it to prevent accidentally disabling it. Should it be required?
  param "bucket_key_enabled" {
    type        = bool
    description = "Specifies whether Amazon S3 should use an S3 Bucket Key with server-side encryption using KMS (SSE-KMS) for new objects in the bucket."
  }

  step "function" "build_encryption_config" {
    src = "./pipelines/s3/functions/put_s3_bucket_encryption"
    runtime = "python:3.10"
    handler = "main.build_encryption_config"
    event = {
      bucket_key_enabled = param.bucket_key_enabled
      kms_master_key_id  = param.kms_master_key_id
      sse_algorithm      = param.sse_algorithm
    }
  }

  step "container" "put_s3_bucket_encryption" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["s3api", "put-bucket-encryption"],
      ["--bucket", param.bucket],
      ["--server-side-encryption-configuration", jsonencode(step.function.build_encryption_config.result)],
    )

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }
}
