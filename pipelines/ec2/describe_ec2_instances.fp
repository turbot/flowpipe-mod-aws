pipeline "describe_ec2_instances" {
  title       = "Describe EC2 Instances"
  description = "Describes the specified instances or all instances."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
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

  step "container" "describe_ec2_instances" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "describe-instances"],
      try(length(param.instance_ids), 0) > 0 ? concat(["--instance-ids"], param.instance_ids) : [],
      param.instance_type != null ? ["--filters", "Name=instance-type,Values=${param.instance_type}"] : [],
      param.ebs_optimized != null ? ["--filters", "Name=ebs-optimized,Values=${param.ebs_optimized}"] : [],
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  # Transform the reservation list of instance lists into a single list of instances for output.
  output "instances" {
    description = "Information about one or more EC2 instances."
    value       = flatten(jsondecode(step.container.describe_ec2_instances.stdout).Reservations.*.Instances)
  }
}
