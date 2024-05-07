pipeline "delete_rds_db_instance" {
  title       = "Delete RDS DB Instance"
  description = "Delete a RDS DB instance."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "db_instance_identifier" {
    type        = string
    description = "The identifier of DB instance. This value is stored as a lowercase string."
  }

  step "container" "delete_rds_db_instance" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "rds", "delete-db-instance", "--skip-final-snapshot"
      "--db-instance-identifier", param.db_instance_identifier,
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "db_instance" {
    description = "Contains the details of an Amazon RDS DB instance."
    value       = jsondecode(step.container.delete_rds_db_instance.stdout).DBInstance
  }
}
