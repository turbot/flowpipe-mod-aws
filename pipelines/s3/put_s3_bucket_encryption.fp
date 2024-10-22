pipeline "put_s3_bucket_encryption" {
  title       = "Put S3 Bucket Encryption"
  description = "Configures encryption settings for an Amazon S3 bucket."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "bucket" {
    type        = string
    description = "The name of the S3 bucket."
  }

  # TODO: AWS defaults to enabling Amazon S3 managed keys (SSE-S3) server-side encryption if this isn't specified,
  # you can chose "aws:kms" or "aws:kms:dsse" for server-side encryption with AWS Key Management Service (AWS KMS) keys (SSE-KMS), or dual-layer server-side encryption with AWS KMS keys (DSSE-KMS) respectively.
  param "sse_algorithm" {
    type        = string
    description = "Server-side encryption algorithm to use for the default encryption."
  }
  
  # Required if using "aws:kms" or "aws:kms:dsse" for parameter "sse_algorithm"
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
    source  = "./pipelines/s3/functions/put_s3_bucket_encryption"
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
      ["--server-side-encryption-configuration", jsonencode(step.function.build_encryption_config.response)],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }
}
