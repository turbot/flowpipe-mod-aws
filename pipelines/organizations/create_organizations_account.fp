pipeline "create_organizations_account" {
  title       = "Create Organizations Account"
  description = "Creates an organizations account."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "email" {
    type        = string
    description = "The email address of the owner to assign to the new member account."
  }

  param "account_name" {
    type        = string
    description = "The friendly name of the member account."
  }

  param "tags" {
    type        = map(string)
    description = "Specifies a list of tags that you want to add to the resource. A tag consists of a key and a value that you define."
  }

  step "container" "create_organizations_account" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["organizations", "create-account", "--email", param.email, "--account-name", param.account_name],
      ["--tags"],
      [join(",", [for key, value in param.tags : "${key}=${value}"])]
    )

    env = credential.aws[param.cred].env

  }

  output "account" {
    description = "Information about the organizations account."
    value       = jsondecode(step.container.create_organizations_account.stdout)
  }
}
