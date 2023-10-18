pipeline "update_ebs_type_conversion" {
  title       = "Convert EBS Volume Types"
  description = "Convert EBS Volume Types."

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
    description = "List of Volume IDs."
  }

  param "volume_type" {
    type        = string
    description = "Specify the desired volume type."
  }

  param "iops" {
    type        = number
    description = "Specify the desired IOPs"
    optional    = true
  }

  step "container" "convert_volume" {
    image = "amazon/aws-cli"

    description = "Get the current state of EBS default encryption."
    cmd = concat(
      [
        "ec2", "modify-volume",
        "--region", "${ var.region }",
        "--volume-type=${param.volume_type}",
        "--volume-id", param.volume_id
      ],
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