pipeline "create_vpc" {
  title       = "Create VPC"
  description = "Creates a new Virtual Private Cloud (VPC) in your AWS account."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "cidr_block" {
    type        = string
    description = "The IPv4 network range for the VPC, in CIDR notation (e.g., 10.0.0.0/16)."
  }

  step "container" "create_vpc" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "ec2", "create-vpc",
      "--cidr-block", param.cidr_block
    ]

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "vpc" {
    description = "Information about the VPC that was created."
    value       = jsondecode(step.container.create_vpc.stdout).Vpc
  }
}
