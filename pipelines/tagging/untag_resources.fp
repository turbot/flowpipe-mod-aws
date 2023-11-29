pipeline "untag_resources" {
  title       = "Untag Resources"
  description = "Removes the specified tags from the specified resources."

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

  param "resource_arns" {
    type        = list(string)
    description = "Specifies the list of ARNs of the resources that you want to apply tags to."
  }

  param "tag_keys" {
    type        = list(string)
    description = "Specifies a list of tag keys that you want to remove from the specified resources."
  }

  step "container" "untag_resources" {
    image = "public.ecr.aws/aws-cli/aws-cli"

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

  output "failed_resources" {
    description = "A map containing a key-value pair for each failed item that couldn’t be tagged. The key is the ARN of the failed resource."
    value       = jsondecode(step.container.untag_resources.stdout)
  }
}
