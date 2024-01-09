pipeline "test_create_sns_topic" {
  title       = "Test Create SNS Topic"
  description = "Test the create_sns_topic pipeline."

  tags = {
    type = "test"
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "region" {
    type        = string
    description = local.region_param_description
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
      cred   = param.cred
      region = param.region
      name   = param.topic_name
      tags   = {
        Name = param.topic_name
        Disposable = "true"
      }
    }
  }

  step "pipeline" "set_sns_topic_attributes" {
    if         = !is_error(step.pipeline.create_sns_topic)
    depends_on = [step.pipeline.create_sns_topic]
    pipeline   = pipeline.set_sns_topic_attributes
    args = {
      cred            = param.cred
      region          = param.region
      topic_arn       = step.pipeline.create_sns_topic.output.topic_arn
      attribute_name  = param.attribute_name
      attribute_value = param.attribute_value
    }
  }

  step "pipeline" "get_sns_topic_attributes" {
    if         = !is_error(step.pipeline.create_sns_topic)
    depends_on = [step.pipeline.set_sns_topic_attributes]
    pipeline   = pipeline.get_sns_topic_attributes
    args = {
      cred      = param.cred
      region    = param.region
      topic_arn = step.pipeline.create_sns_topic.output.topic_arn
    }
  }

  step "pipeline" "delete_sns_topic" {
    if         = !is_error(step.pipeline.create_sns_topic)
    depends_on = [step.pipeline.get_sns_topic_attributes]

    pipeline = pipeline.delete_sns_topic
    args = {
      cred      = param.cred
      region    = param.region
      topic_arn = step.pipeline.create_sns_topic.output.topic_arn
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
    value = {
      "create_sns_topic"         = !is_error(step.pipeline.create_sns_topic) ? "pass" : "fail: ${error_message(step.pipeline.create_sns_topic)}"
      "set_sns_topic_attributes" = !is_error(step.pipeline.set_sns_topic_attributes) ? "pass" : "fail: ${error_message(step.pipeline.set_sns_topic_attributes)}"
      "get_sns_topic_attributes" = !is_error(step.pipeline.get_sns_topic_attributes) ? "pass" : "fail: ${error_message(step.pipeline.get_sns_topic_attributes)}"
      "delete_sns_topic"         = !is_error(step.pipeline.delete_sns_topic) ? "pass" : "fail: ${error_message(step.pipeline.delete_sns_topic)}"
    }
  }

}
