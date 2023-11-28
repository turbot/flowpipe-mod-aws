pipeline "create_vpc_security_group" {
  title       = "Create EC2 Security Group"
  description = "Creates an Amazon EC2 security group."

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
    image = "amazon/aws-cli"

    cmd = concat(
      ["ec2", "create-security-group"],
      ["--group-name", param.group_name],
      ["--description", param.description],
      param.vpc_id ? ["--vpc-id", param.vpc_id] : [],
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The JSON output from the AWS CLI."
    value       = jsondecode(step.container.create_vpc_security_group.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.create_vpc_security_group.stderr
  }
}
