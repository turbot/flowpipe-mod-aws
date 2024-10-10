pipeline "delete_ebs_snapshot" {
  title       = "Delete EBS Snapshot"
  description = "Deletes an Amazon EC2 snapshot."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "snapshot_id" {
    type        = string
    description = "The ID of the EC2 snapshot to delete."
  }

  step "container" "delete_ebs_snapshot" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "ec2", "delete-snapshot",
      "--snapshot-id", param.snapshot_id,
    ]

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }
}
