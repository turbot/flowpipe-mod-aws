pipeline "put_s3_bucket_lifecycle_configuration" {
  title       = "Put S3 Bucket Lifecycle Configuration"
  description = "Creates a new lifecycle configuration for the bucket or replaces an existing lifecycle configuration."

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
    description = "Container for lifecycle rules. You can add as many as 1,000 rules."
  }

  step "container" "put_s3_bucket_lifecycle_configuration" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["s3api", "put-bucket-lifecycle-configuration"],
      ["--bucket", param.bucket_name],
      ["--lifecycle-configuration", param.lifecycle_configuration]
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }
}
