pipeline "create_ec2_snapshot" {
  title       = "Create EC2 Snapshot"
  description = "Creates a snapshot of the specified EBS volume."

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

  param "volume_id" {
    type        = string
    description = "The ID of the EBS volume to create a snapshot of."
  }

  step "container" "create_ec2_snapshot" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "create-snapshot", "--volume-id", param.volume_id]
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "snapshot" {
    description = "Information about the created snapshot."
    value       = jsondecode(step.container.create_ec2_snapshot.stdout)
  }
}
