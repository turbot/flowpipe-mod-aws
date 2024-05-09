pipeline "delete_elbv2_load_balancer" {
  title       = "Delete ELBv2 Load Balancer"
  description = "Deletes an Amazon EC2 Load Balancer via the ELBv2 service."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "load_balancer_arn" {
    type        = string
    description = "The ARN of the Load Balancer to delete."
  }

  step "container" "delete_elbv2_load_balancer" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "elbv2", "delete-load-balancer",
      "--load-balancer-arn", param.load_balancer_arn
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}