pipeline "delete_cloudtrail_trail" {
  title       = "Delete CloudTrail Trail"
  description = "Delete a trail with specified name."

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

  step "container" "delete_cloudtrail_trail" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["cloudtrail", "delete-trail", "--name", param.name]
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "trail" {
    description = "Information about the deleted trail."
    value       = step.container.delete_cloudtrail_trail.stdout
  }
}
