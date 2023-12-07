pipeline "set_sns_topic_attributes" {
  title       = "Set SNS Topic Attributes"
  description = "Sets attributes of an Amazon SNS topic."

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "topic_arn" {
    type        = string
    description = "The Amazon Resource Name (ARN) of the Amazon SNS topic."
  }

  param "attribute_name" {
    type        = string
    description = "The name of the attribute to set."
  }

  param "attribute_value" {
    type        = string
    description = "The value to set for the specified attribute."
  }

  step "container" "set_sns_topic_attributes" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["sns", "set-topic-attributes"],
      ["--topic-arn", param.topic_arn],
      ["--attribute-name", param.attribute_name],
      ["--attribute-value", param.attribute_value],
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}
