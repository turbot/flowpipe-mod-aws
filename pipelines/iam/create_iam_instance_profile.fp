pipeline "create_iam_instance_profile" {
  title       = "Create Instance Profile"
  description = "Creates a new instance profile."

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "instance_profile_name" {
    type        = string
    description = "The name of the instance profile to create."
  }

  step "container" "create_iam_instance_profile" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "iam", "create-instance-profile",
      "--instance-profile-name", param.instance_profile_name,
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "instance_profile" {
    description = "A structure containing details about the new instance profile."
    value = jsondecode(step.container.create_iam_instance_profile.stdout).InstanceProfile
  }
}
