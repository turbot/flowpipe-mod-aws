pipeline "run_ec2_instances" {
  title       = "Launch EC2 Instances"
  description = "Launches an Amazon EC2 instance."

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

  param "instance_type" {
    type        = string
    description = "The EC2 instance type (e.g., t2.micro)."
  }

  param "image_id" {
    type        = string
    description = "The ID of the Amazon Machine Image (AMI) to launch."
  }

  param "count" {
    type        = string
    description = "The number of instances to launch."
    default     = "1"
  }

  step "container" "run_ec2_instances" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "ec2", "run-instances",
      "--instance-type", param.instance_type,
      "--image-id", param.image_id,
      "--count", param.count,
    ]

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "instances" {
    description = "The launched EC2 instances."
    value       = jsondecode(step.container.run_ec2_instances.stdout).Instances
  }
}
