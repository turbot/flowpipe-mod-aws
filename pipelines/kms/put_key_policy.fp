pipeline "put_kms_key_policy" {
  title       = "Put KMS Key Policy"
  description = "Puts a policy on the specified KMS key."

  param "region" {
    type        = string
    description = "The AWS region where the KMS key is located."
  }

  param "cred" {
    type        = string
    description = "The AWS credentials to use for authentication."
    default     = "default"
  }

  param "key_id" {
    type        = string
    description = "The ID of the KMS key."
  }

  param "policy" {
    type        = string
    description = "The policy to attach to the KMS key."
  }

  step "container" "put_kms_key_policy" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "kms", "put-key-policy",
      "--key-id", param.key_id,
      "--policy-name", "default",
      "--policy", param.policy
    ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "kms_key_policy" {
    description = "Information about the updated KMS key policy."
    value       = step.container.put_kms_key_policy.stdout
  }
}
