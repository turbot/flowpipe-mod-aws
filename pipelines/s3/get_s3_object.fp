pipeline "get_s3_object" {
  title       = "Get object from S3 bucket"
  description = "Gets an object from an S3 buckets owned by the authenticated sender of the request."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd   = ["s3api", "get-object", "--bucket", param.bucket, "--key", param.key, param.destination]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "object" {
    description = "Object data."
    value       = jsondecode(step.container.get_s3_object.stdout)
  }
}
