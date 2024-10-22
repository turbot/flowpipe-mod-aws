pipeline "delete_elasticache_cluster" {
  title       = "Delete ElastiCache Cluster"
  description = "Deletes a specified ElastiCache cluster."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "cluster_id" {
    type        = string
    description = "The identifier of the ElastiCache cluster to delete."
  }

  step "container" "delete_elasticache_cluster" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "elasticache", "delete-cache-cluster",
      "--cache-cluster-id", param.cluster_id
    ]

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "cache_cluster" {
    description = "Contains all of the attributes of the deleted cluster."
    value       = jsondecode(step.container.delete_elasticache_cluster.stdout).CacheCluster
  }
}