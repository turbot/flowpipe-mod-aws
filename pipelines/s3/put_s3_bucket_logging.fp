pipeline "put_s3_bucket_logging" {
  title       = "Put S3 Bucket logging"
  description = "Creates or modifies the Bucket logging configuration for an Amazon S3 bucket."

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

  param "bucket_logging_status" {
    type        = string
    description = "Amazon S3 bucket logging enabled JSON string policy for this bucket."
  }

  step "container" "put_s3_bucket_logging" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["s3api", "put-bucket-logging"],
      ["--bucket", param.bucket],
      ["--bucket-logging-status", param.bucket_logging_status]
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }
}
