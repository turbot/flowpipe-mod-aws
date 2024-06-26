pipeline "modify_rds_db_cluster" {
  title       = "Modify RDS DB Cluster"
  description = "Modifies settings for a DB cluster."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "db_cluster_identifier" {
    type        = string
    description = "The identifier of the DB cluster to modify. This value is stored as a lowercase string."
  }

  param "deletion_protection" {
    type        = bool
    description = "Enables or disables the deletion protection property of a DB cluster."
    optional    = true
  }

  param "copy_tags_to_snapshot" {
    type        = bool
    description = "Enables or disables the copy tags to snapshot of a DB cluster."
    optional    = true
  }

  param "auto_minor_version_upgrade" {
    type        = bool
    description = "Enables or disables the auto minor version upgrade property of a DB cluster."
    optional    = true
  }

  param "iam_database_authentication" {
    type        = bool
    description = "Enables or disables the IAM database authentication property of a DB cluster."
    optional    = true
  }

  param "backup_retention_period" {
    type        = number
    description = "The number of days to retain automated backups. Setting this parameter to a positive number enables backups. Setting this parameter to 0 disables automated backups."
    optional    = true
  }

  param "apply_immediately" {
    type        = bool
    description = "Specifies whether the modifications in this request and any pending modifications are asynchronously applied as soon as possible, regardless of the PreferredMaintenanceWindow setting for the DB cluster. By default, this parameter is disabled."
    optional    = true
  }

  param "engine_version" {
    type        = string
    description = "Indicates the database engine version."
    optional    = true
  }

  param "engine" {
    type        = string
    description = "Indicates the database engine."
  }

  param "db_cluster_parameter_group_name" {
    type        = string
    description = "The name of the DB cluster parameter group to apply to the DB cluster."
    optional    = true
  }

  param "vpc_security_group_ids" {
    type        = list(string)
    description = "A list of VPC security groups to associate with this DB cluster."
    optional    = true
  }

  param "preferred_backup_window" {
    type        = string
    description = "The daily time range during which automated backups are created if automated backups are enabled, using the BackupRetentionPeriod parameter."
    optional    = true
  }

  param "preferred_maintenance_window" {
    type        = string
    description = "The weekly time range during which system maintenance can occur, in Universal Coordinated Time (UTC)."
    optional    = true
  }

  param "enable_logging" {
    type        = bool
    description = "Enables or disables logging for the DB cluster based on the engine version."
    optional    = true
  }

  step "container" "modify_rds_db_cluster" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["rds", "modify-db-cluster", "--db-cluster-identifier", param.db_cluster_identifier],
      param.apply_immediately != null ? param.apply_immediately ? ["--apply-immediately"] : ["--no-apply-immediately"] : [],
      param.deletion_protection != null ? param.deletion_protection ? ["--deletion-protection"] : ["--no-deletion-protection"] : [],
      param.copy_tags_to_snapshot != null ? param.copy_tags_to_snapshot ? ["--copy-tags-to-snapshot"] : ["--no-copy-tags-to-snapshot"] : [],
      param.auto_minor_version_upgrade != null ? param.auto_minor_version_upgrade ? ["--auto-minor-version-upgrade"] : ["--no-auto-minor-version-upgrade"] : [],
      param.iam_database_authentication != null ? param.iam_database_authentication ? ["--enable-iam-database-authentication"] : ["--no-enable-iam-database-authentication"] : [],
      param.backup_retention_period != null ? ["--backup-retention-period", param.backup_retention_period] : [],
      param.engine_version != null ? ["--engine-version", param.engine_version] : [],
      param.db_cluster_parameter_group_name != null ? ["--db-cluster-parameter-group-name", param.db_cluster_parameter_group_name] : [],
      param.vpc_security_group_ids != null ? ["--vpc-security-group-ids", join(",", param.vpc_security_group_ids)] : [],
      param.preferred_backup_window != null ? ["--preferred-backup-window", param.preferred_backup_window] : [],
      param.preferred_maintenance_window != null ? ["--preferred-maintenance-window", param.preferred_maintenance_window] : [],
      param.enable_logging != null && param.enable_logging && param.engine != null ?
      (contains(["aurora-mysql"], param.engine) ? ["--cloudwatch-logs-export-configuration", jsonencode({
          "EnableLogTypes":["error","general","slowquery","audit"]
        })] :
      contains(["aurora-postgresql"], param.engine) ? ["--cloudwatch-logs-export-configuration",  jsonencode({
          "EnableLogTypes": ["postgresql"]
        })] : []) : [],
    )
    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "db_cluster" {
    description = "Contains the details of an Amazon RDS DB cluster."
    value       = jsondecode(step.container.modify_rds_db_cluster.stdout).DBCluster
  }
}
