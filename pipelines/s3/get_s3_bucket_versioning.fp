pipeline "get_s3_bucket_versioning" {
  title       = "Get S3 Bucket Versioning"
  description = "Get the versioning state of an S3 bucket."

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
    description = "The bucket name."
  }

  step "container" "get_s3_bucket_versioning" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = ["s3api", "get-bucket-versioning", "--bucket", param.bucket]

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "status" {
    description = "The versioning state of the bucket."
    value       = jsondecode(step.container.get_s3_bucket_versioning.stdout).Status
  }
}
