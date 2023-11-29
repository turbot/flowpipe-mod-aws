pipeline "tag_resources" {
  title       = "Tag Resources"
  description = "Applies one or more tags to the specified resources."

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

  param "tags" {
    type        = map(string)
    description = "Specifies a list of tags that you want to add to the specified resources. A tag consists of a key and a value that you define."
  }

  step "container" "tag_resources" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["resourcegroupstaggingapi", "tag-resources", "--resource-arn-list"],
      param.resource_arns,
      ["--tags"],
      [join(",", [for key, value in param.tags: "${key}=${value}"])]
    )

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The AWS CLI output."
    value       = step.container.tag_resources.stdout
  }
}
