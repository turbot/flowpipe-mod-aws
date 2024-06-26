pipeline "modify_neptune_db_cluster" {
  title       = "Modify Neptune DB Cluster"
  description = "Modify a Neptune DB cluster to enable CloudWatch log groups."

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
    description = "The identifier of the Neptune DB cluster."
  }

  param "enable_cloudwatch_log_types" {
    type        = list(string)
    description = "A list of log types to enable for export to CloudWatch."
    optional    = true
  }

  step "container" "modify_db_cluster" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = concat(
      [
        "neptune", "modify-db-cluster",
        "--db-cluster-identifier", param.db_cluster_identifier],
      try(length(param.enable_cloudwatch_log_types), 0) > 0 ? ["--cloudwatch-logs-export-configuration",format("EnableLogTypes=%s", join(",", param.enable_cloudwatch_log_types))] : []
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "db_cluster_modification" {
    description = "Information about the DB cluster modification."
    value       = jsondecode(step.container.modify_db_cluster.stdout).DBCluster
  }
}
