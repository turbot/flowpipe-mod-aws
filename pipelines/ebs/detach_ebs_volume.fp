pipeline "detach_ebs_volume" {
  title       = "Detach EBS Volume"
  description = "Detach an EBS volume."

  param "region" {
    type        = string
    description = local.region_param_description
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

  step "container" "delete_volume" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      [
        "ec2", "detach-volume",
        "--volume-id", param.volume_id
      ],
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}
