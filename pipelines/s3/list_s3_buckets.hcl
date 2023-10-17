pipeline "list_s3_buckets" {
  title = "List S3 Buckets"

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
    }
  }

  output "stdout" {
    value = jsondecode(step.container.list_s3_buckets.stdout)
  }

  output "stderr" {
    value = jsondecode(step.container.list_s3_buckets.stderr)
  }
}
