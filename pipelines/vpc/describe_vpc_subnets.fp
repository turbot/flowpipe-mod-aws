pipeline "describe_vpc_subnets" {
  title       = "Describe VPC Subnets"
  description = "Describes the specified VPC subnets or all subnets."

  tags = {
    type = "featured"
  }

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "subnet_ids" {
    type        = list(string)
    description = "The subnet IDs."
    optional    = true
  }

  param "cidr_block" {
    type        = string
    description = "The CIDR block of the subnet."
    optional    = true
  }

  step "container" "describe_vpc_subnets" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "describe-subnets"],
      try(length(param.subnet_ids), 0) > 0 ? concat(["--subnet-ids"], param.subnet_ids) : [],
      param.cidr_block != null ? ["--filters", "Name=cidrBlock,Values=${param.cidr_block}"] : []
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "subnets" {
    description = "Information about one or more subnets."
    value       = jsondecode(step.container.describe_vpc_subnets.stdout).Subnets
  }
}
