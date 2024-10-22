pipeline "detach_ebs_volume" {
  title       = "Detach EBS Volume"
  description = "Detach an EBS volume."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "volume_id" {
    type        = string
    description = "The ID of the volume."
  }

  step "container" "detach_volume" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      [
        "ec2", "detach-volume",
        "--volume-id", param.volume_id
      ],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "volume_modification" {
    description = "Information about the volume modification."
    value       = jsondecode(step.container.detach_volume.stdout).volume_modification
  }
}
