pipeline "describe_vpc" {
  title       = "Describe VPCs"
  description = "Describes the specified VPCs or all VPCs."

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
    description = "The VPC ID."
  }

  step "container" "describe_vpc" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = ["ec2", "describe-vpcs", "--vpc-ids", param.vpc_id]

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "vpc" {
    description = "Information about the VPC."
    value       = jsondecode(step.container.describe_vpc.stdout)[0]
  }
}
