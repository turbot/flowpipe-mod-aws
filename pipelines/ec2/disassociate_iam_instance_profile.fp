pipeline "disassociate_iam_instance_profile" {
  title       = "Disassociate IAM Instance Profile"
  description = "Disassociate an IAM instance profile from an EC2 instance in AWS."

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = local.access_key_id_param_description
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = local.secret_access_key_param_description
    default     = var.secret_access_key
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

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "iam_instance_profile_association" {
    description = "Information about the IAM instance profile association."
    value       = jsondecode(step.container.disassociate_iam_instance_profile.stdout).IamInstanceProfileAssociation
  }
}
