pipeline "delete_ec2_snapshot" {
  title       = "Delete EC2 Snapshot"
  description = "Deletes an Amazon EC2 snapshot."

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

  param "snapshot_id" {
    type        = string
    description = "The ID of the EC2 snapshot to delete."
  }

  step "container" "delete_ec2_snapshot" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "ec2", "delete-snapshot",
      "--snapshot-id", param.snapshot_id,
    ]

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }
}
