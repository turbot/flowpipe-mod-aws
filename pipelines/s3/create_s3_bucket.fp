pipeline "create_s3_bucket" {
  title       = "Create S3 Bucket"
  description = "Creates a new Amazon S3 bucket."

  tags = {
    type = "featured"
  }

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}
