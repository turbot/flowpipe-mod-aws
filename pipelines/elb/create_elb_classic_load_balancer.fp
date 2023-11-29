pipeline "create_elb_classic_load_balancer" {
  title       = "Create ELB Classic Load Balancer"
  description = "Creates an classic load balancer."

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = local.access_key_id_param_description
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = local.secret_access_key_param_description
    default     = var.secret_access_key
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
    image = "amazon/aws-cli"

    cmd = concat(
      ["elb", "create-load-balancer"],
      ["--load-balancer-name", param.name],
      flatten([for listener in param.listeners : ["--listener", jsonencode(listener)]]),
      ["--availability-zones", join(",", param.availability_zones)]
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The AWS CLI output."
    value       = jsondecode(step.container.create_elb_classic_load_balancer.stdout)
  }
}
