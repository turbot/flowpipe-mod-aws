pipeline "test_create_sns_topic" {
  title       = "Test Create SNS Topic"
  description = "Test the create_sns_topic pipeline."

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

  param "topic_name" {
    type        = string
    description = "The name of the Amazon SNS topic to create."
    default     = "flowpipe-test-${uuid()}"
  }

  param "attribute_name" {
    type        = string
    description = "The name of the attribute to set."
    default     = "DisplayName"
  }

  param "attribute_value" {
    type        = string
    description = "The value to set for the specified attribute."
    default     = "Flowpipe Test Topic"
  }

  step "pipeline" "create_sns_topic" {
    pipeline = pipeline.create_sns_topic
    args = {
      region            = param.region
      access_key_id     = param.access_key_id
      secret_access_key = param.secret_access_key
      name              = param.topic_name
    }
  }

  step "pipeline" "set_sns_topic_attributes" {
    if = !is_error(step.pipeline.create_sns_topic)
    depends_on = [step.pipeline.create_sns_topic]
    pipeline = pipeline.set_sns_topic_attributes
    args = {
      region            = param.region
      access_key_id     = param.access_key_id
      secret_access_key = param.secret_access_key
      topic_arn         = step.pipeline.create_sns_topic.output.topic_arn
      attribute_name    = param.attribute_name
      attribute_value   = param.attribute_value
    }
  }

  step "pipeline" "get_sns_topic_attributes" {
    if = !is_error(step.pipeline.create_sns_topic)
    depends_on = [step.pipeline.set_sns_topic_attributes]
    pipeline = pipeline.get_sns_topic_attributes
    args = {
      region            = param.region
      access_key_id     = param.access_key_id
      secret_access_key = param.secret_access_key
      topic_arn         = step.pipeline.create_sns_topic.output.topic_arn
    }
  }

  step "pipeline" "delete_sns_topic" {
    if = !is_error(step.pipeline.create_sns_topic)
    depends_on = [step.pipeline.get_sns_topic_attributes]

    pipeline = pipeline.delete_sns_topic
    args = {
      region            = param.region
      access_key_id     = param.access_key_id
      secret_access_key = param.secret_access_key
      topic_arn         = step.pipeline.create_sns_topic.output.topic_arn
    }
  }

  output "created_topic_arn" {
    description = "The ARN of the created topic."
    value       = step.pipeline.create_sns_topic.output.topic_arn
  }

  output "topic_attributes" {
    description = "The attributes of the created topic."
    value       = step.pipeline.get_sns_topic_attributes.output.attributes
  }

  output "test_results" {
    description = "Test results for each step."
    value       = {
      "create_sns_topic" = !is_error(step.pipeline.create_sns_topic) ? "pass" : "fail: ${error_message(step.pipeline.create_sns_topic)}"
      "set_sns_topic_attributes" = !is_error(step.pipeline.set_sns_topic_attributes) ? "pass" : "fail: ${error_message(step.pipeline.set_sns_topic_attributes)}"
      "get_sns_topic_attributes" = !is_error(step.pipeline.get_sns_topic_attributes) ? "pass" : "fail: ${error_message(step.pipeline.get_sns_topic_attributes)}"
      "delete_sns_topic" = !is_error(step.pipeline.delete_sns_topic) ? "pass" : "fail: ${error_message(step.pipeline.delete_sns_topic)}"
    }
  }

}
