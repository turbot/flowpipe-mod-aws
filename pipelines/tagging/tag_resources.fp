pipeline "tag_resources" {
  title       = "Tag Resources"
  description = "Applies one or more tags to the specified resources."

  tags = {
    recommended = "true"
  }

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
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
      [join(",", [for key, value in param.tags : "${key}=${value}"])]
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "failed_resources" {
    description = "A map containing a key-value pair for each failed item that couldn’t be tagged. The key is the ARN of the failed resource."
    value       = jsondecode(step.container.tag_resources.stdout).FailedResourcesMap
  }
}
