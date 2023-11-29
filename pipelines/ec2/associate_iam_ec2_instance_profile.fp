pipeline "associate_iam_ec2_instance_profile" {
  title       = "Associate IAM to EC2 Instance Profile"
  description = "Associates an IAM instance profile with a running or stopped instance. You cannot associate more than one IAM instance profile with an instance."

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

  param "instance_id" {
    type        = string
    description = "The ID of the instance."
  }

  param "iam_instance_profile" {
    type        = string
    description = "The IAM instance profile."
  }

  step "container" "associate_iam_ec2_instance_profile" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "ec2", "associate-iam-instance-profile",
      "--instance-id", param.instance_id,
      "--iam-instance-profile", param.iam_instance_profile,
    ]
    env = {
        AWS_REGION            = param.region
        AWS_ACCESS_KEY_ID     = param.access_key_id
        AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "iam_instance_profile_association" {
    description = "The IAM instance profile association."
    value = jsondecode(step.container.associate_iam_ec2_instance_profile.stdout)
  }
}
