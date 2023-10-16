pipeline "list_s3_buckets" {
  title       = "List S3 Buckets"
  description = "Returns a list of all buckets owned by the authenticated sender of the request."

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

  param "session_token" {
    type        = string
    description = local.session_token_param_description
    default     = var.session_token
    optional    = true
  }

  param "query" {
    type        = string
    description = "A JMESPath query to use in filtering the response data."
    optional    = true
  }

  step "container" "list_s3_buckets" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["s3api", "list-buckets"],
      param.query != null ? ["--query", param.query] : [],
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
      AWS_SESSION_TOKEN     = param.session_token
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = jsondecode(step.container.list_s3_buckets.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.list_s3_buckets.stderr
  }
}
