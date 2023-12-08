pipeline "test_list_iam_users" {
  title = "Test List IAM Users"

  tags = {
    type = "test"
  }

  param "user_name" {
    type = string
    description = "The name of the user to create."
    default = "flowpipe-test-${uuid()}"
  }

  step "pipeline" "create_iam_user" {
    pipeline = pipeline.create_iam_user
    args = {
      user_name = param.user_name
    }
  }

  step "pipeline" "list_iam_users" {
    if = !is_error(step.pipeline.create_iam_user)
    pipeline = pipeline.list_iam_users
  }

  step "pipeline" "list_iam_groups_for_user" {
    if = !is_error(step.pipeline.create_iam_user)
    pipeline = pipeline.list_iam_groups_for_user
    args = {
      user_name = param.user_name
    }
  }

  step "pipeline" "create_iam_access_key" {
    if = !is_error(step.pipeline.create_iam_user)
    pipeline = pipeline.create_iam_access_key
    args = {
      user_name = param.user_name
    }
  }

  step "pipeline" "list_iam_access_keys" {
    depends_on = [step.pipeline.create_iam_access_key]
    pipeline = pipeline.list_iam_access_keys
    args = {
      user_name = param.user_name
    }
  }

  step "pipeline" "delete_iam_access_key" {
    depends_on = [step.pipeline.list_iam_access_keys]
    pipeline = pipeline.delete_iam_access_key
    args = {
      user_name = param.user_name
      access_key_id = step.pipeline.create_iam_access_key.output.access_key.AccessKeyId
    }
  }

  step "pipeline" "delete_iam_user" {
    if = !is_error(step.pipeline.create_iam_user)
    depends_on = [step.pipeline.delete_iam_access_key]
    pipeline = pipeline.delete_iam_user
    args = {
      user_name = param.user_name
    }
  }

  output "test_result" {
    description = "Test results for each step."
    value = {
      "create_iam_user" = !is_error(step.pipeline.create_iam_user) ? "pass" : "fail: ${error_message(step.pipeline.create_iam_user)}"
      "list_iam_users" = !is_error(step.pipeline.list_iam_users) ? "pass" : "fail: ${error_message(step.pipeline.list_iam_users)}"
      "list_iam_groups_for_user" = !is_error(step.pipeline.list_iam_groups_for_user) ? "pass" : "fail: ${error_message(step.pipeline.list_iam_groups_for_user)}"
      "create_iam_access_key" = !is_error(step.pipeline.create_iam_access_key) ? "pass" : "fail: ${error_message(step.pipeline.create_iam_access_key)}"
      "list_iam_access_keys" = !is_error(step.pipeline.list_iam_access_keys) ? "pass" : "fail: ${error_message(step.pipeline.list_iam_access_keys)}"
      "delete_iam_access_key" = !is_error(step.pipeline.delete_iam_access_key) ? "pass" : "fail: ${error_message(step.pipeline.delete_iam_access_key)}"
      "delete_iam_user" = !is_error(step.pipeline.delete_iam_user) ? "pass" : "fail: ${error_message(step.pipeline.delete_iam_user)}"
    }
  }
}
