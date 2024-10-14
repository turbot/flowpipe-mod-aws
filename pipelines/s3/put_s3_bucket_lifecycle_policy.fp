pipeline "put_s3_bucket_lifecycle_policy" {
  title       = "Put S3 Bucket Lifecycle Policy"
  description = "Put lifecycle rules to a specified S3 bucket."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "bucket_name" {
    type        = string
    description = "The name of the S3 bucket."
  }

  param "lifecycle_configuration" {
    type        = string
    description = "Specifies lifecycle configuration rules for an Amazon S3 bucket."
  }

  step "container" "put_s3_bucket_lifecycle_policy" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["s3api", "put-bucket-lifecycle"],
      ["--bucket", param.bucket_name],
      ["--lifecycle-configuration", param.lifecycle_configuration]
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }
}
