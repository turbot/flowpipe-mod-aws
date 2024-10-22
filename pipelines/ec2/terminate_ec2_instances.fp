pipeline "terminate_ec2_instances" {
  title       = "Terminate EC2 Instances"
  description = "Terminates one or more Amazon EC2 instances."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "instance_ids" {
    type        = list(string)
    description = "A list of EC2 instance IDs to terminate."
  }

  step "container" "terminate_instances" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "terminate-instances"],
      try(length(param.instance_ids), 0) > 0 ? concat(["--instance-ids"], param.instance_ids) : [],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "instances" {
    description = "Information about the terminated instances."
    value       = jsondecode(step.container.terminate_instances.stdout).TerminatingInstances
  }
}
