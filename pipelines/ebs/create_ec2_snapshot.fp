pipeline "create_ec2_snapshot" {
  title       = "Create EC2 Snapshot"
  description = "Creates a snapshot of the specified EBS volume."

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

  param "volume_id" {
    type        = string
    description = "The ID of the EBS volume to create a snapshot of."
  }

  step "container" "create_ec2_snapshot" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["ec2", "create-snapshot", "--volume-id", param.volume_id]
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The AWS CLI output."
    value       = jsondecode(step.container.create_ec2_snapshot.stdout)
  }
}
