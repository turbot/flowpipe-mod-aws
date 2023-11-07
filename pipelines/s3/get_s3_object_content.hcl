pipeline "get_s3_object_content" {
  title       = "Get S3 Object Content"
  description = "Gets the content of an S3 object."

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
    description = "S3 bucket name."
  }

  param "path_to_file" {
    type        = string
    description = "Path to S3 file."
  }

  step "container" "get_s3_object_content" {
    image = "amazon/aws-cli"
    cmd = ["s3", "cp", "s3://${param.bucket}/${param.path_to_file}", "-"]

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = step.container.get_s3_object_content.stdout
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.get_s3_object_content.stderr
  }
}
