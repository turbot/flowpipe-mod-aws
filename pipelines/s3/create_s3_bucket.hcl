pipeline "create_s3_bucket" {
  title       = "Create S3 Bucket"
  description = "Creates a new Amazon S3 bucket."

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
    description = "The name of the new S3 bucket."
  }

  param "acl" {
    type        = string
    description = "The access control list (ACL) for the new bucket (e.g., private, public-read)."
    optional = true
  }

  step "container" "create_s3_bucket" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["s3api", "create-bucket"],
      ["--bucket", param.bucket],
      param.acl != null ? ["--acl", param.acl] : [],
      # Regions other than us-east-1 require the LocationConstraint parameter
      param.region != "us-east-1" ? ["--create-bucket-configuration LocationConstraint=", param.region] : [],
    )

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.create_s3_bucket.stderr
  }
}
