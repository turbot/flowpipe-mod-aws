pipeline "modify_elb_attributes" {
  title       = "Modify ELB Attributes"
  description = "Modifies attributes of a Load Balancer."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "load_balancer_name" {
    type        = string
    description = "The name of the load balancer whose attributes are to be modified."
  }

  param "enable_connection_draining" {
    type        = bool
    description = "Enable or disable connection draining."
    default     = true
  }

  param "connection_draining_timeout" {
    type        = number
    description = "Timeout in seconds for connection draining."
    default     = 300
    optional    = true
  }

  step "container" "set_elb_attributes" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "elb", "modify-load-balancer-attributes",
      "--load-balancer-name", param.load_balancer_name,
      "--load-balancer-attributes", jsonencode({
        "ConnectionDraining": {
          "Enabled": param.enable_connection_draining,
          "Timeout": param.connection_draining_timeout
        }
      })
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "load_balancer_attributes" {
    description = "Attributes after modification, specifically the connection draining settings."
    value       = jsondecode(step.container.set_elb_attributes.stdout).LoadBalancerAttributes.ConnectionDraining
  }
}
