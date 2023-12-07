pipeline "list_s3_buckets" {
  title       = "List S3 Buckets"
  description = "Returns a list of all buckets owned by the authenticated sender of the request."

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


  param "query" {
    type        = string
    description = "A JMESPath query to use in filtering the response data."
    optional    = true
  }

  step "container" "list_s3_buckets" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["s3api", "list-buckets"],
      param.query != null ? ["--query", param.query] : [],
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "buckets" {
    description = "The list of buckets owned by the requester."
    value       = jsondecode(step.container.list_s3_buckets.stdout).Buckets
  }
}
