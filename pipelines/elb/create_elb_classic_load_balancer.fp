pipeline "create_elb_classic_load_balancer" {
  title       = "Create ELB Classic Load Balancer"
  description = "Creates an classic load balancer."

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

  param "listeners" {
    type        = list(map(string))
    description = "A list of listener configurations. Each listener configuration should include 'Protocol', 'LoadBalancerPort', 'InstanceProtocol', and 'InstancePort'."
  }

  param "availability_zones" {
    type        = list(string)
    description = "A list of availability zones to associate with the load balancer."
  }

  step "container" "create_elb_classic_load_balancer" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["elb", "create-load-balancer"],
      ["--load-balancer-name", param.name],
      flatten([for listener in param.listeners : ["--listener", jsonencode(listener)]]),
      ["--availability-zones", join(",", param.availability_zones)]
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "elb_dns_name" {
    description = "The DNS name of the load balancer."
    value       = jsondecode(step.container.create_elb_classic_load_balancer.stdout).DNSName
  }
}
