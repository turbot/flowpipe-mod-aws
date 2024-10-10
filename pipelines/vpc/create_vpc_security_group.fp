pipeline "create_vpc_security_group" {
  title       = "Create VPC Security Group"
  description = "Creates a security group."

  tags = {
    recommended = "true"
  }

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "group_name" {
    type        = string
    description = "The name for the security group."
  }

  param "description" {
    type        = string
    description = "A description for the security group."
  }

  param "vpc_id" {
    type        = string
    description = "The ID of the VPC to associate the security group with."
    optional    = true
  }

  step "container" "create_vpc_security_group" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "create-security-group"],
      ["--group-name", param.group_name],
      ["--description", param.description],
      param.vpc_id ? ["--vpc-id", param.vpc_id] : [],
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "group_id" {
    description = "The group ID of the security group."
    value       = jsondecode(step.container.create_vpc_security_group.stdout).GroupId
  }
}
