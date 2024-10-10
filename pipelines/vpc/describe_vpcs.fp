pipeline "describe_vpcs" {
  title       = "Describe VPCs"
  description = "Describes the specified VPCs or all VPCs."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "vpc_ids" {
    type        = list(string)
    description = "The VPC IDs."
    optional    = true
  }

  step "container" "describe_vpcs" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "describe-vpcs"],
      try(length(param.vpc_ids), 0) > 0 ? concat(["--vpc-ids"], param.vpc_ids) : []
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "vpcs" {
    description = "Information about one or more VPCs."
    value       = jsondecode(step.container.describe_vpcs.stdout).Vpcs
  }
}
