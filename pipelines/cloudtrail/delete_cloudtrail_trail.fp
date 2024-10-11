pipeline "delete_cloudtrail_trail" {
  title       = "Delete CloudTrail Trail"
  description = "Delete a trail with specified name."

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

  step "container" "delete_cloudtrail_trail" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["cloudtrail", "delete-trail", "--name", param.name]
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }
}
