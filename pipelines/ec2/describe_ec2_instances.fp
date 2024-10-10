pipeline "describe_ec2_instances" {
  title       = "Describe EC2 Instances"
  description = "Describes the specified instances or all instances."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "region" {
    type        = string
    description = local.region_param_description
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

  param "tags" {
    type        = map(string)
    description = "One or more tags. If specified, only those instances that match the tags are returned."
    optional    = true
  }

  step "container" "describe_ec2_instances" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "describe-instances"],
      try(length(param.instance_ids), 0) > 0 ? concat(["--instance-ids"], param.instance_ids) : [],
      param.instance_type != null ? ["--filters", "Name=instance-type,Values=${param.instance_type}"] : [],
      param.ebs_optimized != null ? ["--filters", "Name=ebs-optimized,Values=${param.ebs_optimized}"] : [],
      param.tags != null ? flatten([
        ["--filters"],
        [for k, v in param.tags : concat(["Name=tag:${k},Values=${v}"])]
      ]) : []
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  # Transform the reservation list of instance lists into a single list of instances for output.
  output "instances" {
    description = "Information about one or more EC2 instances."
    value       = flatten(jsondecode(step.container.describe_ec2_instances.stdout).Reservations.*.Instances)
  }
}
