pipeline "untag_resources" {
  title = "Untag Resources"

  param "region" {
    type        = string
    description = "The name of the Region."
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = "The ID for this access key."
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = "The secret key used to sign requests."
    default     = var.secret_access_key
  }

  param "resource_arns" {
    type        = list(string)
    description = "Specifies the list of ARNs of the resources that you want to apply tags to."
  }

  param "tag_keys" {
    type        = list(string)
    description = "Specifies a list of tag keys that you want to remove from the specified resources."
  }

  step "container" "untag_resources" {
    image = "amazon/aws-cli"

    cmd = concat(
      ["resourcegroupstaggingapi", "untag-resources", "--resource-arn-list"],
      param.resource_arns,
      ["--tag-keys"],
      param.tag_keys
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    value = step.container.untag_resources.stdout
  }

  output "stderr" {
    value = step.container.untag_resources.stderr
  }
}
