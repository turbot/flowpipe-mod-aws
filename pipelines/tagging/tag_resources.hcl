pipeline "tag_resources" {
  title       = "Tag Resources"
  description = "Applies one or more tags to the specified resources."

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

  param "tags" {
    type        = map(string)
    description = "Specifies a list of tags that you want to add to the specified resources. A tag consists of a key and a value that you define."
  }

  step "container" "tag_resources" {
    image = "amazon/aws-cli"

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
    description = "The JSON output from the AWS CLI."
    value       = step.container.tag_resources.stdout
  }

  output "stderr" {
    description = "The error output from the AWS CLI."
    value       = step.container.tag_resources.stderr
  }
}
