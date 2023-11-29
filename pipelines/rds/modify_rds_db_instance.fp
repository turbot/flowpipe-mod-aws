pipeline "modify_rds_db_instance" {
  title       = "Modify RDS DB Instance"
  description = "Modifies settings for a DB instance."

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

  param "db_instance_identifier" {
    type        = string
    description = "The identifier of DB instance to modify. This value is stored as a lowercase string."
  }

  param "publicly_accessible" {
    type        = bool
    description = "Specifies whether the DB instance is publicly accessible."
    optional    = true
  }

  param "db_instance_class" {
    type        = string
    description = "The new compute and memory capacity of the DB instance, for example `db.m4.large`."
    optional    = true
  }

  param "backup_retention_period" {
    type        = number
    description = "The number of days to retain automated backups. Setting this parameter to a positive number enables backups. Setting this parameter to 0 disables automated backups."
    optional    = true
  }

  param "apply_immediately" {
    type        = bool
    description = "Specifies whether the modifications in this request and any pending modifications are asynchronously applied as soon as possible, regardless of the PreferredMaintenanceWindow setting for the DB instance. By default, this parameter is disabled."
    optional    = true
  }

  step "container" "modify_rds_db_instance" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["rds", "modify-db-instance", "--apply-immediately", "--db-instance-identifier", param.db_instance_identifier],
      param.apply_immediately != null ? param.apply_immediately ? ["--apply-immediately"] : ["--no-apply-immediately"] : [],
      param.publicly_accessible != null ? param.publicly_accessible ? ["--publicly-accessible"] : ["--no-publicly-accessible"] : [],
      param.db_instance_class != null ? ["--db-instance-class", param.db_instance_class] : [],
      param.backup_retention_period != null ? ["--backup-retention-period", param.backup_retention_period] : [],
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "db_instance" {
    description = "Contains the details of an Amazon RDS DB instance."
    value       = jsondecode(step.container.modify_rds_db_instance.stdout)
  }
}
