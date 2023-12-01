pipeline "describe_ec2_instances" {
  title       = "Describe EC2 Instances"
  description = "Describes the specified instances or all instances."

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "cred" {
    type        = string
    description = "Name for credentials to use. If not provided, the default credentials will be used."
    default     = "default"
  }

  param "instance_ids" {
    type        = list(string)
    description = "The instance IDs."
    optional    = true
  }

  param "instance_type" {
    type        = string
    description = "The type of instance (for example, t2.micro)."
    optional    = true
  }

  param "ebs_optimized" {
    type        = bool
    description = "A Boolean that indicates whether the instance is optimized for Amazon EBS I/O."
    optional    = true
  }

  param "query" {
    type        = string
    description = "The query that is used to filter the results of DescribeInstances."
    optional    = true
  }

  step "container" "describe_ec2_instances" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "describe-instances"],
      try(length(param.instance_ids), 0) > 0 ? concat(["--instance-ids"], param.instance_ids) : [],
      param.instance_type != null ? ["--filters", "Name=instance-type,Values=${param.instance_type}"] : [],
      param.ebs_optimized != null ? ["--filters", "Name=ebs-optimized,Values=${param.ebs_optimized}"] : [],
      param.query != null ? ["--query", param.query] : [],
    )

    env = merge(credential.aws[param.cred].env,{
      AWS_REGION = param.region
    })
  }

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value       = jsondecode(step.container.describe_ec2_instances.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value       = step.container.describe_ec2_instances.stderr
  }
}
