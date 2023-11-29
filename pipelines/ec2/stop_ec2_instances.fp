pipeline "stop_ec2_instances" {
  title       = "Stop EC2 Instances"
  description = "Stops an Amazon EBS-backed instance."

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

  param "instance_ids" {
    type        = list(string)
    description = "The IDs of the instances."
  }

  step "container" "stop_ec2_instances" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = concat(
      ["ec2", "stop-instances", "--instance-ids"],
      param.instance_ids
    )
    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stopping_ec2_instances" {
    description = "Information about the stopped instances."
    value = jsondecode(step.container.stop_ec2_instances.stdout)
  }
}
