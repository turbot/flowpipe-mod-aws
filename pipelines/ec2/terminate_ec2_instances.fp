pipeline "terminate_ec2_instances" {
  title       = "Terminate EC2 Instances"
  description = "Terminates one or more Amazon EC2 instances."

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
    description = "A list of EC2 instance IDs to terminate."
  }

  step "container" "terminate_instances" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "terminate-instances"],
      try(length(param.instance_ids), 0) > 0 ? concat(["--instance-ids"], param.instance_ids) : [],
    )

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "terminating_instances" {
    description = "Information about the terminated instances."
    value       = jsondecode(step.container.terminate_instances.stdout)
  }
}
