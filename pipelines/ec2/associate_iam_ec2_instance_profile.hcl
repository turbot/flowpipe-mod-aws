pipeline "associate_iam_ec2_instance_profile" {
  title       = "Associate IAM to EC2 Instance Profile"
  description = "Associates an IAM instance profile with a running or stopped instance. You cannot associate more than one IAM instance profile with an instance."

  param "region" {
    type        = string
    description = "The name of the region."
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

  param "instance_id" {
    type        = string
    description = "The ID of the instance."
  }

  param "iam_instance_profile" {
    type        = string
    description = "The IAM instance profile."
  }

  step "container" "associate_iam_ec2_instance_profile" {
    image = "amazon/aws-cli"
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

  output "stdout" {
    description = "The standard output stream from the AWS CLI."
    value = jsondecode(step.container.associate_iam_ec2_instance_profile.stdout)
  }

  output "stderr" {
    description = "The standard error stream from the AWS CLI."
    value = step.container.associate_iam_ec2_instance_profile.stderr
  }
}
