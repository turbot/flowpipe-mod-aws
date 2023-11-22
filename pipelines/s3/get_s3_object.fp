pipeline "get_s3_object" {
  title       = "Get object from S3 bucket"
  description = "Gets an object from an S3 buckets owned by the authenticated sender of the request."

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
    description = "Bucket name."
    default     = ""
  }

  param "key" {
    type        = string
    description = "Key to object."
    default     = ""
  }

  param "destination" {
    type        = string
    description = "Key to object."
    default     = ""
  }

  step "container" "get_s3_object" {
    image = "amazon/aws-cli"
    cmd = ["s3api", "get-object", "--bucket", param.bucket, "--key", param.key, param.destination]

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "object" {
    description = "Object data."
    value       = jsondecode(step.container.get_s3_object.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.get_s3_object.stderr
  }
}
