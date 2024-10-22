pipeline "create_cloudtrail_trail" {
  title       = "Create CloudTrail Trail"
  description = "Creates a trail with specified name."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "name" {
    type        = string
    description = "The name of the trail."
  }

  param "bucket_name" {
    type        = string
    description = "The name of the bucket."
  }

  param "is_multi_region_trail" {
    type        = bool
    description = "Indicate whether a multi region trail."
  }

  param "include_global_service_events" {
    type        = bool
    description = "Indicate whether to include the global service events."
  }

  param "enable_log_file_validation" {
    type        = bool
    description = "Indicate whether to enable log file validation."
  }

  step "container" "create_cloudtrail_trail" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["cloudtrail", "create-trail", "--name", param.name],
      param.bucket_name != null ? ["--s3-bucket-name", param.bucket_name] : [],
      param.is_multi_region_trail != null ? ["--is-multi-region-trail"] : [],
      param.include_global_service_events != null ? ["--include-global-service-events"] : [],
      param.enable_log_file_validation != null ? ["--enable-log-file-validation"] : [],

    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "trail" {
    description = "Information about the created trail."
    value       = jsondecode(step.container.create_cloudtrail_trail.stdout)
  }
}
