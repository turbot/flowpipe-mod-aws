pipeline "modify_ebs_volume" {
  title       = "Modify EBS Volume"
  description = "Modify several parameters of an existing EBS volume, including volume size, volume type, and IOPS capacity."

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

  param "volume_type" {
    type        = string
    description = "The target EBS volume type of the volume."
    optional    = true
  }

  param "iops" {
    type        = number
    description = "The target IOPS rate of the volume."
    optional    = true
  }

  param "size" {
    type        = number
    description = "The size of the volume."
    optional    = true
  }

  step "container" "convert_volume" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      [
        "ec2", "modify-volume",
        "--volume-id", param.volume_id
      ],
      param.volume_type != null ? ["--volume-type", param.volume_type] : [],
      param.iops != null ? ["--iops", param.iops] : [],
      param.size != null ? ["--size", param.size] : [],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "volume_modification" {
    description = "Information about the volume modification."
    value       = jsondecode(step.container.convert_volume.stdout).VolumeModification
  }
}
