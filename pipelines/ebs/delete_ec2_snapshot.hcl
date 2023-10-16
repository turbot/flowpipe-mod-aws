pipeline "delete_ec2_snapshot" {
  title       = "Delete EC2 Snapshot"
  description = "Deletes an Amazon EC2 snapshot."

  param "region" {
    type        = string
    description = "The name of the region."
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = "The ID for this access key."
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = "The secret key used to sign requests."
    default     = var.secret_access_key
  }

  param "snapshot_id" {
    type        = string
    description = "The ID of the EC2 snapshot to delete."
  }

  step "container" "delete_ec2_snapshot" {
    image = "amazon/aws-cli"

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

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = jsondecode(step.container.delete_ec2_snapshot.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.delete_ec2_snapshot.stderr
  }
}
