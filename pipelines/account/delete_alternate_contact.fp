pipeline "delete_alternate_contact" {
  title       = "Delete Alternate Contact"
  description = "Delete an alternate contact for an AWS account."

  param "cred" {
    type        = string
    description = "The credential profile to use."
    default     = "default"
  }

  param "account_id" {
    type        = string
    description = "The AWS account ID."
  }

  param "alternate_contact_type" {
    type        = string
    description = "The type of alternate contact (BILLING, OPERATIONS, SECURITY)."
  }

  step "container" "delete_alternate_contact" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["account", "delete-alternate-contact"],
      ["--account-id", param.account_id],
      ["--alternate-contact-type", param.alternate_contact_type]
    )

    env = credential.aws[param.cred].env
  }
}
