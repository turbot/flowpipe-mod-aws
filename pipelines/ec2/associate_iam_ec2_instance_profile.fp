pipeline "associate_iam_ec2_instance_profile" {
  title       = "Associate IAM to EC2 Instance Profile"
  description = "Associates an IAM instance profile with a running or stopped instance. You cannot associate more than one IAM instance profile with an instance."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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
    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "iam_instance_profile_association" {
    description = "The IAM instance profile association."
    value       = jsondecode(step.container.associate_iam_ec2_instance_profile.stdout).IamInstanceProfileAssociation
  }
}
