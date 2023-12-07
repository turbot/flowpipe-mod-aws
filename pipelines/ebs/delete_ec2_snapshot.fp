pipeline "delete_ec2_snapshot" {
  title       = "Delete EC2 Snapshot"
  description = "Deletes an Amazon EC2 snapshot."

  tags = {
    type = "featured"
  }

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

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}
