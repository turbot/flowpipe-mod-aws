pipeline "modify_ebs_volume" {
  title       = "Modify EBS Volume"
  description = "Modify several parameters of an existing EBS volume, including volume size, volume type, and IOPS capacity."

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
    image = "amazon/aws-cli"

    cmd = concat(
      [
        "ec2", "modify-volume",
        "--volume-id", param.volume_id
      ],
      param.volume_type != null ? ["--volume-type", param.volume_type] : [],
      param.iops != null ? ["--iops", param.iops] : [],
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    value = jsondecode(step.container.convert_volume.stdout)
  }

  output "stderr" {
    value = step.container.convert_volume.stderr
  }
}
