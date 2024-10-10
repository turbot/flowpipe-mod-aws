pipeline "put_alternate_contact" {
  title       = "Put Alternate Contact"
  description = "Sets an alternate contact for an AWS account."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "account_id" {
    type        = string
    description = "The AWS account ID."
  }

  param "alternate_contact_type" {
    type        = string
    description = "The type of alternate contact (BILLING, OPERATIONS, SECURITY)."
  }

  param "email_address" {
    type        = string
    description = "The email address of the alternate contact."
  }

  param "name" {
    type        = string
    description = "The name of the alternate contact."
  }

  param "phone_number" {
    type        = string
    description = "The phone number of the alternate contact."
  }

  param "title" {
    type        = string
    description = "The title of the alternate contact."
  }

  step "container" "put_alternate_contact" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["account", "put-alternate-contact"],
      ["--account-id", param.account_id],
      ["--alternate-contact-type", param.alternate_contact_type],
      ["--email-address", param.email_address],
      ["--name", param.name],
      ["--phone-number", param.phone_number],
      ["--title", param.title]
    )

    env = param.conn.env
  }
}
