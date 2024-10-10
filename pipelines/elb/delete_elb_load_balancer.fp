pipeline "delete_elb_load_balancer" {
  title       = "Delete Elastic Load Balancer"
  description = "Deletes an Amazon ELB (Elastic Load Balancer)."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "load_balancer_name" {
    type        = string
    description = "The name of the load balancer to delete."
  }

  step "container" "delete_elb_load_balancer" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "elb", "delete-load-balancer",
      "--load-balancer-name", param.load_balancer_name,
    ]

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }
}
