pipeline "terminate_emr_clusters" {
  title       = "Terminate EMR Clusters"
  description = "Terminates one or more AWS EMR clusters."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "cluster_ids" {
    type        = list(string)
    description = "A list of EMR cluster IDs to terminate."
  }

  step "container" "terminate_clusters" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["emr", "terminate-clusters"],
      try(length(param.cluster_ids), 0) > 0 ? concat(["--cluster-ids"], param.cluster_ids) : [],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "clusters" {
    description = "Information about the terminated clusters."
    value       = jsondecode(step.container.terminate_clusters.stdout).TerminatedClusters
  }
}
