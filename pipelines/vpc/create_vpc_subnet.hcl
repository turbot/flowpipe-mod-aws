pipeline "create_vpc_subnet" {
  title       = "Create VPC Subnet"
  description = "Creates a new subnet in an existing Virtual Private Cloud (VPC) in your AWS account."

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

  param "vpc_id" {
    type        = string
    description = "The ID of the VPC in which to create the subnet."
  }

  param "cidr_block" {
    type        = string
    description = "The IPv4 network range for the subnet, in CIDR notation (e.g., 10.0.0.0/24)."
  }

  step "container" "create_vpc_subnet" {
    image = "amazon/aws-cli"

    cmd = [
      "ec2", "create-subnet",
      "--vpc-id", param.vpc_id,
      "--cidr-block", param.cidr_block
    ]

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = jsondecode(step.container.create_vpc_subnet.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.create_vpc_subnet.stderr
  }
}
