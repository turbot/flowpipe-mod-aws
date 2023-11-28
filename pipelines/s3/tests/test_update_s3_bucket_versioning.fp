# TODO: Switch all steps and outputs to use is_error() once supported for container steps
# TODO: Do steps need to check stderr/is_error() or should they use depends_on?
pipeline "test_update_s3_bucket_versioning" {
  title       = "Test Update S3 Bucket Versioning"
  description = "Test the update_s3_bucket_versioning pipeline."

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

  param "bucket" {
    type        = string
    description = "The name of the bucket."
    default     = "flowpipe-test-${uuid()}"
  }

  step "echo" "base_args" {
    output "base_args" {
      value = {
        region            = param.region
        access_key_id     = param.access_key_id
        secret_access_key = param.secret_access_key
        bucket            = param.bucket
      }
    }
  }

  step "pipeline" "create_s3_bucket" {
    pipeline = pipeline.create_s3_bucket
    args     = step.echo.base_args.output.base_args
  }

  step "pipeline" "test_update_s3_bucket_versioning_enable_disable" {
    if       = step.pipeline.create_s3_bucket.output.stderr == ""
    pipeline = pipeline.test_update_s3_bucket_versioning_enable_disable
    args     = step.echo.base_args.output.base_args

    # Ignore errors so we always delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_s3_bucket" {
    if         = step.pipeline.create_s3_bucket.output.stderr == ""
    depends_on = [step.pipeline.test_update_s3_bucket_versioning_enable_disable]

    pipeline = pipeline.delete_s3_bucket
    args     = step.echo.base_args.output.base_args
  }

  output "bucket" {
    description = "Bucket name used in the test."
    value = param.bucket
  }

  output "test_results" {
    description = "Test results for each step."
    value       = {
      "create_s3_bucket"                    = step.pipeline.create_s3_bucket.output.stderr == "" ? "pass" : "fail: ${step.pipeline.create_s3_bucket.errors}"
      "enable_disable_s3_bucket_versioning" = step.pipeline.test_update_s3_bucket_versioning_enable_disable
      "delete_s3_bucket"                    = step.pipeline.delete_s3_bucket.output.stderr == "" ? "pass" : "fail: ${step.pipeline.create_s3_bucket.errors}"
    }
  }

}

pipeline "test_update_s3_bucket_versioning_enable_disable" {
  title       = "Test Enable and Disable S3 Bucket Versioning"
  description = "Test enabling and disabling S3 bucket versioning."

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

  param "bucket" {
    type        = string
    description = "The name of the bucket."
    default     = "flowpipe-test-${uuid()}"
  }

  step "echo" "base_args" {
    output "base_args" {
      value = {
        region            = param.region
        access_key_id     = param.access_key_id
        secret_access_key = param.secret_access_key
        bucket            = param.bucket
      }
    }
  }

  # New buckets have versioning disabled by default
  step "pipeline" "enable_s3_bucket_versioning" {
    pipeline = pipeline.update_s3_bucket_versioning
    args     = merge(step.echo.base_args.output.base_args, { versioning = true })
  }

  # The update command doesn't return the new state
  step "pipeline" "check_s3_bucket_versioning_enabled" {
    if = step.pipeline.enable_s3_bucket_versioning.output.stderr == ""

    pipeline = pipeline.get_s3_bucket_versioning
    args     = step.echo.base_args.output.base_args
  }

  step "pipeline" "disable_s3_bucket_versioning" {
    if = step.pipeline.check_s3_bucket_versioning_enabled.output.stderr == ""

    pipeline = pipeline.update_s3_bucket_versioning
    args     = merge(step.echo.base_args.output.base_args, { versioning = false })
  }

  # The update command doesn't return the new state
  step "pipeline" "check_s3_bucket_versioning_disabled" {
    if = step.pipeline.disable_s3_bucket_versioning.output.stderr == ""

    pipeline = pipeline.get_s3_bucket_versioning
    args     = step.echo.base_args.output.base_args
  }

  output "enable_s3_bucket_versioning" {
    description = "Check for pipeline.enable_s3_bucket_versioning."
    value       = step.pipeline.enable_s3_bucket_versioning.output.stderr == "" ? "pass" : "fail: ${step.pipeline.enable_s3_bucket_versioning.errors}"
  }

  output "check_s3_bucket_versioning_enabled" {
    description = "Check for pipeline.check_s3_bucket_versioning_enabled."
    value       = step.pipeline.check_s3_bucket_versioning_enabled.output.stderr == "" && step.pipeline.check_s3_bucket_versioning_enabled.output.status == "Enabled" ? "pass" : "fail: ${step.pipeline.check_s3_bucket_versioning_enabled.errors}"
  }

  output "disable_s3_bucket_versioning" {
    description = "Check for pipeline.disable_s3_bucket_versioning."
    value       = step.pipeline.disable_s3_bucket_versioning.output.stderr == "" ? "pass" : "fail: ${step.pipeline.disable_s3_bucket_versioning.errors}"
  }

  output "check_s3_bucket_versioning_disabled" {
    description = "Check for pipeline.check_s3_bucket_versioning_disabled."
    value       = step.pipeline.check_s3_bucket_versioning_disabled.output.stderr == "" && step.pipeline.check_s3_bucket_versioning_disabled.output.status == "Suspended" ? "pass" : "fail: ${step.pipeline.check_s3_bucket_versioning_disabled.errors}"
  }

}
