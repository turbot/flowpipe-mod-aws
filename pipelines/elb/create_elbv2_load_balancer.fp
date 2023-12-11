pipeline "create_elbv2_load_balancer" {
  title       = "Create ELB v2 Load Balancer"
  description = "Creates a v2 load balancer (application, network or gateway)."

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

  param "name" {
    type        = string
    description = "The name for the load balancer."
  }

  param "type" {
    type        = string
    description = "The type of load balancer (e.g., 'application' for Application Load Balancer, 'network' for Network Load Balancer)."
  }

  param "availability_zones" {
    type        = list(string)
    description = "A list of availability zones to associate with the load balancer."
  }

  step "container" "create_elbv2_load_balancer" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["elbv2", "create-load-balancer"],
      ["--name", param.name],
      ["--type", param.type],
      flatten([for az in param.availability_zones : ["--availability-zones", az]])
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "load_balancers" {
    description = "Information about the load balancer."
    value       = jsondecode(step.container.create_elbv2_load_balancer.stdout).LoadBalancers
  }
}
