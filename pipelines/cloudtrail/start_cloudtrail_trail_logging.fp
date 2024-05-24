pipeline "start_cloudtrail_trail_logging" {
  title       = "Start CloudTrail Trail logging"
  description = "Start logging into the bucket."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "name" {
    type        = string
    description = "The name of the trail."
  }

  step "container" "start_cloudtrail_trail_logging" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = ["cloudtrail", "start-logging", "--name", param.name]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}
