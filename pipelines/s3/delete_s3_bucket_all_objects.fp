pipeline "delete_s3_bucket_all_objects" {
  title       = "Delete S3 Bucket all Objects"
  description = "Deletes all the objects of the specified S3 bucket."

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
    description = "The name of the S3 bucket to delete objects."
  }

  step "container" "delete_s3_bucket_all_objects" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "s3",
      "rm",
      "s3://${param.bucket}"
    ]

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }
}
