pipeline "modify_rds_db_instance" {

  param "region" {
    type        = string
    description = "The name of the Region."
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

  param "apply_immediately" {
    type        = bool
    description = "Specifies whether the modifications in this request and any pending modifications are asynchronously applied as soon as possible, regardless of the PreferredMaintenanceWindow setting for the DB instance. By default, this parameter is disabled."
    optional    = true
  }

  step "container" "modify_rds_db_instance" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["rds", "modify-db-instance", "--apply-immediately", "--db-instance-identifier", param.db_instance_identifier],
      param.apply_immediately != null ? param.apply_immediately ? ["--apply-immediately"] : ["--no-apply-immediately"] : [],
      param.publicly_accessible != null ? param.publicly_accessible ? ["--publicly-accessible"] : ["--no-publicly-accessible"] : [],
      param.db_instance_class != null ? ["--db-instance-class", param.db_instance_class] : [],
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    value = jsondecode(step.container.modify_rds_db_instance.stdout)
  }

  output "stderr" {
    value = step.container.modify_rds_db_instance.stderr
  }
}
