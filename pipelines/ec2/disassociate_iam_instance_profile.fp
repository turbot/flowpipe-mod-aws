pipeline "disassociate_iam_instance_profile" {
  title       = "Disassociate IAM Instance Profile"
  description = "Disassociate an IAM instance profile from an EC2 instance in AWS."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "association_id" {
    type        = string
    description = "The ID of the IAM instance profile association."
  }

  step "container" "disassociate_iam_instance_profile" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "disassociate-iam-instance-profile"],
      ["--association-id", param.association_id],
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "iam_instance_profile_association" {
    description = "Information about the IAM instance profile association."
    value       = jsondecode(step.container.disassociate_iam_instance_profile.stdout).IamInstanceProfileAssociation
  }
}
