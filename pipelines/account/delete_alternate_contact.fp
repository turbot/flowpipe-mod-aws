pipeline "delete_alternate_contact" {
  title       = "Delete Alternate Contact"
  description = "Delete an alternate contact for an AWS account."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "alternate_contact_type" {
    type        = string
    description = "The type of alternate contact (BILLING, OPERATIONS, SECURITY)."
  }

  step "container" "delete_alternate_contact" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["account", "delete-alternate-contact"],
      ["--alternate-contact-type", param.alternate_contact_type]
    )

    env = param.conn.env
  }
}
