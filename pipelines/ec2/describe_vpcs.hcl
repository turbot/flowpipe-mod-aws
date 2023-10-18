pipeline "describe_vpcs" {
  title       = "Describe VPCs"
  description = "Describes the specified VPCs or all VPCs."

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

  param "vpc_ids" {
    type        = list(string)
    description = "The VPC IDs."
    optional    = true
  }

  step "container" "describe_vpcs" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["ec2", "describe-vpcs"],
      try(length(param.vpc_ids), 0) > 0 ? concat(["--vpc-ids"], param.vpc_ids) : []
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The JSON output from the AWS CLI."
    value       = jsondecode(step.container.describe_vpcs.stdout)
  }

  output "stderr" {
    description = "The error output from the AWS CLI."
    value       = step.container.describe_vpcs.stderr
  }
}
