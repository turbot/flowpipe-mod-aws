pipeline "create_account_assignment" {
  title       = "Create Account Assignment"
  description = "Assigns access to a principal for a specified AWS account using a specified permission set."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "instance_arn" {
    type        = string
    description = "The ARN of the IAM Identity Center instance under which the operation will be executed."
  }

  param "permission_set_arn" {
    type        = string
    description = "The ARN of the permission set that the admin wants to grant the principal access to."
  }

  param "principal_id" {
    type        = string
    description = "An identifier for an object in IAM Identity Center, such as a user or group. PrincipalIds are GUIDs (For example, f81d4fae-7dec-11d0-a765-00a0c91e6bf6)."
  }

  param "principal_type" {
    type        = string
    description = "The entity type for which the assignment will be created. Possible values are USER and GROUP."
  }

  param "target_id" {
    type        = string
    description = "TargetID is an Amazon Web Services account identifier, (For example, 123456789012)."
  }

  param "target_type" {
    type        = string
    description = "The entity type for which the assignment will be created."
    default     = "AWS_ACCOUNT"
  }

  step "container" "create_account_assignment" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["sso-admin", "create-account-assignment", "--instance-arn", param.instance_arn, "--permission-set-arn", param.permission_set_arn, "--principal-id", param.principal_id, "--principal-type", param.principal_type, "--target-id", param.target_id, "--target-type", param.target_type],
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "assignment" {
    description = "Information about the account assignment."
    value       = jsondecode(step.container.create_account_assignment.stdout)
  }
}
