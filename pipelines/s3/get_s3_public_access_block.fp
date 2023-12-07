pipeline "get_s3_public_access_block" {
  title       = "Get S3 Public Access Block Configuration"
  description = "Retrieve public access block configuration for an S3 bucket in AWS."

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

  param "bucket_name" {
    type        = string
    description = "Name of the S3 bucket to retrieve the public access block configuration."
  }

  step "container" "get_s3_public_access_block" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = ["s3api", "get-public-access-block","--bucket", param.bucket_name]
    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
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
