pipeline "create_elbv2_load_balancer" {
  title       = "Create ELB v2 Load Balancer"
  description = "Creates a v2 load balancer (application, network or gateway)."

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

  param "type" {
    type        = string
    description = "The type of load balancer (e.g., 'application' for Application Load Balancer, 'network' for Network Load Balancer)."
  }

  param "availability_zones" {
    type        = list(string)
    description = "A list of availability zones to associate with the load balancer."
  }

  step "container" "create_elbv2_load_balancer" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["elbv2", "create-load-balancer"],
      ["--name", param.name],
      ["--type", param.type],
      flatten([for az in param.availability_zones : ["--availability-zones", az]])
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = jsondecode(step.container.create_elbv2_load_balancer.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.create_elbv2_load_balancer.stderr
  }
}
