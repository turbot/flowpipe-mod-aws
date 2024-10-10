pipeline "release_eip" {
  title       = "Release VPC EIP"
  description = "Release a VPC Elastic IP address."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "allocation_id" {
    type        = string
    description = "The ID representing the allocation of the address for use with EC2-VPC."
  }

  step "container" "release_eip" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      [
        "ec2", "release-address",
        "--allocation-id", param.allocation_id
      ],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }
}
