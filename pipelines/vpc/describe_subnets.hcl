pipeline "describe_subnets" {
  title       = "Describe Subnets"
  description = "Describes the specified subnets or all subnets."

  param "region" {
    type        = string
    description = "The name of the Region."
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = "The ID for this access key."
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = "The secret key used to sign requests."
    default     = var.secret_access_key
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

  step "container" "describe_subnets" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["ec2", "describe-subnets"],
      try(length(param.subnet_ids), 0) > 0 ? concat(["--subnet-ids"], param.subnet_ids) : [],
      param.cidr_block != null ? ["--filters", "Name=cidrBlock,Values=${param.cidr_block}"] : []
    )

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The JSON output from the AWS CLI."
    value       = jsondecode(step.container.describe_subnets.stdout)
  }

  output "stderr" {
    description = "The error output from the AWS CLI."
    value       = step.container.describe_subnets.stderr
  }
}
