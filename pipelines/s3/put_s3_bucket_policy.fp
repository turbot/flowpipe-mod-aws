pipeline "put_s3_bucket_policy" {
  title       = "Put S3 Bucket Policy"
  description = "Put a policy to a specified S3 bucket."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "bucket_name" {
    type        = string
    description = "The name of the S3 bucket."
  }

  param "policy" {
    type        = string
    description = "A JSON string of the policy for the S3 bucket."
  }

  step "container" "put_s3_bucket_policy" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["s3api", "put-bucket-policy"],
      ["--bucket", param.bucket_name],
      ["--policy", param.policy]
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}
