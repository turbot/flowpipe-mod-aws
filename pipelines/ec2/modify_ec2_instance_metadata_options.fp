pipeline "modify_ec2_instance_metadata_options" {
  title       = "Modify EC2 Instance Metadata Options"
  description = "Modify the instance metadata parameters on a running or stopped instance."

  tags = {
    type = "featured"
  }

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

  param "instance_id" {
    type        = string
    description = "The ID of the EC2 instance."
  }

  param "http_tokens" {
    type        = string
    description = "IMDSv2 uses token-backed sessions. Set the use of HTTP tokens to optional (in other words, set the use of IMDSv2 to optional ) or required (in other words, set the use of IMDSv2 to required)."
    optional    = true
  }

  param "http_endpoint" {
    type        = string
    description = "Enables or disables the HTTP metadata endpoint on your instances."
    optional    = true
  }

  step "container" "modify_ec2_instance_metadata_options" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "modify-instance-metadata-options"],
      ["--instance-id", param.instance_id],
      param.http_tokens != null ? ["--http-tokens", param.http_tokens] : [],
      param.http_endpoint != null ? ["--http-endpoint", param.http_endpoint] : [],
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "instance_metadata_options" {
    description = "The metadata options for the instance."
    value       = jsondecode(step.container.modify_ec2_instance_metadata_options.stdout).InstanceMetadataOptions
  }
}
