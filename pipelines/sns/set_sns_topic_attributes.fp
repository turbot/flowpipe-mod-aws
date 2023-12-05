pipeline "set_sns_topic_attributes" {
  title       = "Set SNS Topic Attributes"
  description = "Sets attributes of an Amazon SNS topic."

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

    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }
}
