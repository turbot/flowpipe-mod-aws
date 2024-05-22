pipeline "enable_kms_key_rotation" {
  title       = "Enable KMS Key Rotation"
  description = "Enables automatic key rotation for an AWS KMS key."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "key_id" {
    type        = string
    description = "The ID of the KMS key for which to enable key rotation."
  }

  step "container" "enable_key_rotation" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "kms",
      "enable-key-rotation",
      "--key-id", "${param.key_id}"
    ]
    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "result" {
    description = "The result of the enable-key-rotation command."
    value       = step.container.enable_key_rotation.stdout
  }
}
