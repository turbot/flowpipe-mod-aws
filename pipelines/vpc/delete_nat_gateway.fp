pipeline "delete_nat_gateway" {
  title       = "Delete NAT Gateway"
  description = "Deletes a NAT gateway."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "nat_gateway_id" {
    type        = string
    description = "The ID of the NAT gateway."
  }

  step "container" "delete_nat_gateway" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "ec2", "delete-nat-gateway",
      "--nat-gateway-id", param.nat_gateway_id,
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}
