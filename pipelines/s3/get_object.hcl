pipeline "get_s3_object" {
  title       = "Get object from S3 bucket"
  description = "Gets an object from an S3 buckets owned by the authenticated sender of the request."

  param "region" {
    type        = string
    description = "The name of the Region."
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

  param "bucket_name" {
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
      AWS_SESSION_TOKEN     = param.session_token
    }
  }

  output "stdout" {
    value = step.container.get_s3_object.stdout
  }

  output "stderr" {
    value = step.container.get_s3_object.stderr
  }
}
