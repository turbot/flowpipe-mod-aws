pipeline "describe_ebs_snapshots" {
  title       = "Describe EBS Snapshots"
  description = "Describes the specified EBS snapshots or all available snapshots."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "snapshot_ids" {
    type        = list(string)
    description = "The snapshot IDs."
    optional    = true
  }

  param "owner_ids" {
    type        = list(string)
    description = "Filter results by the IDs of the AWS accounts that own the snapshots."
    optional    = true
  }

  param "volume_ids" {
    type        = list(string)
    description = "Filter results by the IDs of the EBS volumes associated with the snapshots."
    optional    = true
  }

  step "container" "describe_ebs_snapshots" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "describe-snapshots"],
      try(length(param.snapshot_ids), 0) > 0 ? concat(["--snapshot-ids"], param.snapshot_ids) : [],
      try(length(param.owner_ids), 0) > 0 ? concat(["--owner-ids"], param.owner_ids) : [],
      try(length(param.volume_ids), 0) > 0 ? concat(["--filter", "Name=volume-id,Values=${param.volume_ids}"]) : []
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "snapshots" {
    description = "Information about the snapshots."
    value       = jsondecode(step.container.describe_ebs_snapshots.stdout)
  }
}
