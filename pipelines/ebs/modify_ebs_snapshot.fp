pipeline "modify_ebs_snapshot" {
  title       = "Modify EBS Snapshot"
  description = "Modifies an attribute of an Amazon EBS snapshot."

  param "region" {
    type        = string
    description = "The AWS region in which the snapshot exists."
  }

  param "cred" {
    type        = string
    description = "The credentials used to authenticate with AWS."
    default     = "default"
  }

  param "snapshot_id" {
    type        = string
    description = "The ID of the EBS snapshot to modify."
  }

  step "container" "modify_snapshot_attribute" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "ec2", "modify-snapshot-attribute",
      "--snapshot-id", param.snapshot_id,
      "--attribute", "createVolumePermission",
      "--operation-type", "remove",
      "--group", "all"
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}
