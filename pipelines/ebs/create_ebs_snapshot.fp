pipeline "create_ebs_snapshot" {
  title       = "Create EBS Snapshot"
  description = "Creates a snapshot of the specified EBS volume."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "volume_id" {
    type        = string
    description = "The ID of the EBS volume to create a snapshot of."
  }

  step "container" "create_ebs_snapshot" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "create-snapshot", "--volume-id", param.volume_id]
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "snapshot" {
    description = "Information about the created snapshot."
    value       = jsondecode(step.container.create_ebs_snapshot.stdout)
  }
}
