pipeline "modify_rds_db_instance" {
  title       = "Modify RDS DB Instance"
  description = "Modifies settings for a DB instance."

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
    description = "The identifier of DB instance to modify. This value is stored as a lowercase string."
  }

  param "publicly_accessible" {
    type        = bool
    description = "Specifies whether the DB instance is publicly accessible."
    optional    = true
  }

  param "deletion_protection" {
    type        = bool
    description = "Enables or disables the deletion protection property of a DB instance."
    optional    = true
  }

  param "copy_tags_to_snapshot" {
    type        = bool
    description = "Enables or disables the copy tags to snapshot of a DB instance."
    optional    = true
  }

  param "auto_minor_version_upgrade" {
    type        = bool
    description = "Enables or disables the auto minor version upgrade property of a DB instance."
    optional    = true
  }

  param "iam_database_authentication" {
    type        = bool
    description = "Enables or disables the IAM database authentication property of a DB instance."
    optional    = true
  }

  param "multi_az" {
    type        = bool
    description = "Enables or disables the Multi-AZ property of a DB instance."
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

  param "engine_version" {
    type        = string
    description = "Indicates the database engine version."
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
      param.engine_version != null ? ["--engine-version", param.engine_version] : [],
      param.deletion_protection != null ? param.deletion_protection ? ["--deletion-protection"] : ["--no-deletion-protection"] : [],
      param.copy_tags_to_snapshot != null ? param.copy_tags_to_snapshot ? ["--copy-tags-to-snapshot"] : ["--no-copy-tags-to-snapshot"] : [],
      param.auto_minor_version_upgrade != null ? param.auto_minor_version_upgrade ? ["--auto-minor-version-upgrade"] : ["--no-auto-minor-version-upgrade"] : [],
      param.iam_database_authentication != null ? param.iam_database_authentication ? ["--enable-iam-database-authentication"] : ["--no-enable-iam-database-authentication"] : [],
      param.multi_az != null ? param.multi_az ? ["--multi-az"] : ["--no-multi-az"] : [],
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "db_instance" {
    description = "Contains the details of an Amazon RDS DB instance."
    value       = jsondecode(step.container.modify_rds_db_instance.stdout).DBInstance
  }
}
