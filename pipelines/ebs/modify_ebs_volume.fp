pipeline "modify_ebs_volume" {
  title       = "Modify EBS Volume"
  description = "Modify several parameters of an existing EBS volume, including volume size, volume type, and IOPS capacity."

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

  step "container" "convert_volume" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      [
        "ec2", "modify-volume",
        "--volume-id", param.volume_id
      ],
      param.volume_type != null ? ["--volume-type", param.volume_type] : [],
      param.iops != null ? ["--iops", param.iops] : [],
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "volume_modification" {
    description = "Information about the volume modification."
    value       = jsondecode(step.container.convert_volume.stdout).VolumeModification
  }
}
