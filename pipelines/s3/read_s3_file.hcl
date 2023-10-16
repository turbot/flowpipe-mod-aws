pipeline "read_s3_file" {
  title       = "Reads an object from S3 bucket"
  description = "Gets an object from an S3 buckets owned by the authenticated sender of the request."

  param "region" {
    type        = string
    description = "The name of the region."
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = "The ID for this access key."
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = "The secret key used to sign requests."
    default     = var.secret_access_key
  }

  param "session_token" {
    type        = string
    description = "The secret key used to sign requests."
    default     = var.session_token
    optional    = true
  }

  param "bucket" {
    type        = string
    description = "S3 bucket name."
  }

  param "path_to_file" {
    type        = string
    description = "Path to S3 file."
  }

  step "container" "read_s3_file" {
    image = "amazon/aws-cli"
    cmd = ["s3", "cp", "s3://${param.bucket}/${param.path_to_file}", "-"]

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
      AWS_SESSION_TOKEN     = param.session_token
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = step.container.read_s3_file.stdout
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.read_s3_file.stderr
  }
}
