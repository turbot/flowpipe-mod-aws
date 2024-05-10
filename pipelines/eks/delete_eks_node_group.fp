pipeline "delete_eks_node_group" {
  title       = "Delete EKS Node Group"
  description = "Deletes a specified node group from an Amazon EKS cluster."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "cluster_name" {
    type        = string
    description = "The name of the EKS cluster associated with the node group."
  }

  param "node_group_name" {
    type        = string
    description = "The name of the node group to delete."
  }

  step "container" "delete_eks_node_group" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "eks", "delete-nodegroup",
      "--cluster-name", param.cluster_name,
      "--nodegroup-name", param.node_group_name
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "node_group" {
    description = "The full description of the deleted node group."
    value       = jsondecode(step.container.delete_eks_node_group.stdout).nodegroup
  }
}