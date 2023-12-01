pipeline "delete_elb_load_balancer" {
  title       = "Delete Elastic Load Balancer"
  description = "Deletes an Amazon ELB (Elastic Load Balancer)."

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

  param "load_balancer_name" {
    type        = string
    description = "The name of the load balancer to delete."
  }

  step "container" "delete_elb_load_balancer" {
    image = "amazon/aws-cli"

    cmd = [
      "elb", "delete-load-balancer",
      "--load-balancer-name", param.load_balancer_name,
    ]

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }
}
