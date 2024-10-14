pipeline "put_s3_bucket_policy" {
  title       = "Put S3 Bucket Policy"
  description = "Creates or modifies the Bucket policy configuration for an Amazon S3 bucket."

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

  param "policy" {
    type        = string
    description = "Amazon S3 bucket policy for the bucket and its objects."
  }

  step "container" "put_s3_bucket_policy" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["s3api", "put-bucket-policy"],
      ["--bucket", param.bucket],
      ["--policy", param.policy]
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }
}
