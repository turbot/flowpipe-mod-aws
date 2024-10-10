pipeline "list_s3_buckets" {
  title       = "List S3 Buckets"
  description = "Returns a list of all buckets owned by the authenticated sender of the request."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  step "container" "list_s3_buckets" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd   = ["s3api", "list-buckets"]
    env   = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "buckets" {
    description = "The list of buckets owned by the requester."
    value       = jsondecode(step.container.list_s3_buckets.stdout).Buckets
  }
}
