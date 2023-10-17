pipeline "describe_ec2_instances" {
  title       = "Describe EC2 Instances"
  description = "Describes the specified instances or all instances."

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
    image = "amazon/aws-cli"

    cmd = concat(
      ["ec2", "describe-instances"],
      try(length(param.instance_ids), 0) > 0 ? concat(["--instance-ids"], param.instance_ids) : [],
      param.instance_type != null ? ["--filters", "Name=instance-type,Values=${param.instance_type}"] : [],
      param.ebs_optimized != null ? ["--filters", "Name=ebs-optimized,Values=${param.ebs_optimized}"] : []
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    value = jsondecode(step.container.describe_ec2_instances.stdout)
  }

  output "stderr" {
    value = jsondecode(step.container.describe_ec2_instances.stderr)
  }
}
