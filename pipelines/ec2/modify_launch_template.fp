pipeline "modify_launch_template" {
  title       = "Modify EC2 Launch Template"
  description = "Updates an EC2 Launch Template based on provided settings for network interfaces."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "launch_template_id" {
    type        = string
    description = "The ID of the launch template to modify."
  }

  param "version_description" {
    type        = string
    description = "Description for the new version of the launch template."
    default     = "Update network interface settings"
  }

  param "associate_public_ip" {
    type        = bool
    description = "Specify whether instances launched from this template should have a public IP associated."
    default     = false
  }

  step "container" "update_launch_template" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "ec2", "modify-launch-template",
      "--launch-template-id", param.launch_template_id,
      "--version-description", param.version_description,
      "--launch-template-data", jsonencode({
        "NetworkInterfaces": [
          {
            "DeviceIndex": 0,
            "AssociatePublicIpAddress": param.associate_public_ip
          }
        ]
      })
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "template_modification" {
    description = "Details about the modification of the launch template."
    value       = "Launch template ${param.launch_template_id} modified successfully. Public IP association set to ${param.associate_public_ip}."
  }
}
