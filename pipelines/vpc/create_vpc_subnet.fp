pipeline "create_vpc_subnet" {
  title       = "Create VPC Subnet"
  description = "Creates a new subnet in an existing Virtual Private Cloud (VPC) in your AWS account."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
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
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "ec2", "create-subnet",
      "--vpc-id", param.vpc_id,
      "--cidr-block", param.cidr_block
    ]

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "subnet" {
    description = "Information about the subnet that was created."
    value       = jsondecode(step.container.create_vpc_subnet.stdout).Subnet
  }
}
