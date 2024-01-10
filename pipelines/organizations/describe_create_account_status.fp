pipeline "describe_create_account_status" {
  title       = "Describe Create Account Status"
  description = "Retrieves the current status of an asynchronous request to create an account. This operation can be called only from the organization's management account or by a member account that is a delegated administrator for an Amazon Web Services service."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "create_account_request_id" {
    type        = string
    description = "Specifies the Id value that uniquely identifies the CreateAccount request."
  }

  step "container" "describe_create_account_status" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["organizations", "describe-create-account-status", "--create-account-request-id", param.create_account_request_id]
    )

    env = credential.aws[param.cred].env
  }

  output "status" {
    description = "Information about the organizations account."
    value       = jsondecode(step.container.describe_create_account_status.stdout)
  }
}
