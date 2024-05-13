pipeline "delete_route53_health_check" {
  title       = "Delete Route 53 Health Check"
  description = "Deletes an Amazon Route 53 health check."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "health_check_id" {
    type        = string
    description = "The ID of the Route 53 health check to delete."
  }

  step "container" "delete_route53_health_check" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "route53", "delete-health-check",
      "--health-check-id", param.health_check_id
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}