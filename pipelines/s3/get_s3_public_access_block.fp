pipeline "get_s3_public_access_block" {
  title       = "Get S3 Public Access Block Configuration"
  description = "Retrieve public access block configuration for an S3 bucket in AWS."

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

  param "bucket_name" {
    type        = string
    description = "Name of the S3 bucket to retrieve the public access block configuration."
  }

  step "container" "get_s3_public_access_block" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = ["s3api", "get-public-access-block","--bucket", param.bucket_name]
    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = jsondecode(step.container.get_s3_public_access_block.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.get_s3_public_access_block.stderr
  }

}
