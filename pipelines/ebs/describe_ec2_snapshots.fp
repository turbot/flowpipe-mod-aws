pipeline "describe_ec2_snapshots" {
  title       = "Describe EC2 Snapshots"
  description = "Describes the specified EBS snapshots or all available snapshots."

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

  step "container" "describe_ec2_snapshots" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "describe-snapshots"],
      try(length(param.snapshot_ids), 0) > 0 ? concat(["--snapshot-ids"], param.snapshot_ids) : [],
      try(length(param.owner_ids), 0) > 0 ? concat(["--owner-ids"], param.owner_ids) : [],
      try(length(param.volume_ids), 0) > 0 ? concat(["--filter", "Name=volume-id,Values=${param.volume_ids}"]) : []
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "snapshots" {
    description = "Information about the snapshots."
    value       = jsondecode(step.container.describe_ec2_snapshots.stdout)
  }
}
