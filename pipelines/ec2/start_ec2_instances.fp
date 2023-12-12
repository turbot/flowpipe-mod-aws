pipeline "start_ec2_instances" {
  title       = "Start EC2 Instances"
  description = "Starts an Amazon EBS-backed instance."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "instance_ids" {
    type        = list(string)
    description = "The IDs of the instances."
  }

  step "container" "start_ec2_instances" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = concat(
      ["ec2", "start-instances", "--instance-ids"],
      param.instance_ids
    )
    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "instances" {
    description = "Information about the started instances."
    value       = jsondecode(step.container.start_ec2_instances.stdout).StartingInstances
  }
}
