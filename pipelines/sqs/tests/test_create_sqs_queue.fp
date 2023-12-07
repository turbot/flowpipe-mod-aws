pipeline "test_create_sqs_queue" {
  title       = "Test Create SQS Queue"
  description = "Test the create_sqs_queue pipeline."

  tags = {
    type = "test"
  }

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "queue_name" {
    type        = string
    description = "The name of the Amazon SQS queue to create."
    default     = "flowpipe-test-${uuid()}"
  }

  param "attributes" {
    type        = string
    description = "A map of attributes to set."
    default     = jsonencode({
      "DelaySeconds" = "10"
    })
  }

  step "pipeline" "create_sqs_queue" {
    pipeline = pipeline.create_sqs_queue
    args = {
      region     = param.region
      queue_name = param.queue_name
    }
  }

  step "pipeline" "set_sqs_queue_attributes" {
    if = !is_error(step.pipeline.create_sqs_queue)
    depends_on = [step.pipeline.create_sqs_queue]
    pipeline = pipeline.set_sqs_queue_attributes
    args = {
      region     = param.region
      queue_url  = step.pipeline.create_sqs_queue.output.queue_url
      attributes = param.attributes
    }
  }

  step "pipeline" "get_sqs_queue_attributes" {
    if = !is_error(step.pipeline.create_sqs_queue)
    depends_on = [step.pipeline.set_sqs_queue_attributes]
    pipeline = pipeline.get_sqs_queue_attributes
    args = {
      region    = param.region
      queue_url = step.pipeline.create_sqs_queue.output.queue_url
    }
  }

  step "pipeline" "delete_sqs_queue" {
    if = !is_error(step.pipeline.create_sqs_queue)
    depends_on = [step.pipeline.get_sqs_queue_attributes]

    pipeline = pipeline.delete_sqs_queue
    args = {
      region    = param.region
      queue_url = step.pipeline.create_sqs_queue.output.queue_url
    }
  }

  output "created_queue_url" {
    description = "The ARN of the created queue."
    value       = step.pipeline.create_sqs_queue.output.queue_url
  }

  output "queue_attributes" {
    description = "The attributes of the created queue."
    value       = step.pipeline.get_sqs_queue_attributes.output
  }

  output "test_results" {
    description = "Test results for each step."
    value       = {
      "create_sqs_queue" = !is_error(step.pipeline.create_sqs_queue) ? "pass" : "fail: ${error_message(step.pipeline.create_sqs_queue)}"
      "set_sqs_queue_attributes" = !is_error(step.pipeline.set_sqs_queue_attributes) ? "pass" : "fail: ${error_message(step.pipeline.set_sqs_queue_attributes)}"
      "get_sqs_queue_attributes" = !is_error(step.pipeline.get_sqs_queue_attributes) ? "pass" : "fail: ${error_message(step.pipeline.get_sqs_queue_attributes)}"
      "delete_sqs_queue" = !is_error(step.pipeline.delete_sqs_queue) ? "pass" : "fail: ${error_message(step.pipeline.delete_sqs_queue)}"
    }
  }

}
