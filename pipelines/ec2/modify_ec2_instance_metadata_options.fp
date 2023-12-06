pipeline "modify_ec2_instance_metadata_options" {
  title       = "Modify EC2 Instance Metadata Options"
  description = "Modify the instance metadata parameters on a running or stopped instance."

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

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "instance_metadata_options" {
    description = "The metadata options for the instance."
    value       = jsondecode(step.container.modify_ec2_instance_metadata_options.stdout).InstanceMetadataOptions
  }
}
