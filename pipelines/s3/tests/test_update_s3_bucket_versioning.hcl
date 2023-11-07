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
    default     = "flowpipe-test-bucket-${uuid()}"
  }

  # Handle regions better and use --create-bucket-configuration
  step "pipeline" "create_s3_bucket" {
    pipeline = pipeline.create_s3_bucket
    args = {
     # Handle regions better and use --create-bucket-configuration
     #region            = param.region
     access_key_id     = param.access_key_id
     secret_access_key = param.secret_access_key
     bucket            = param.bucket
    }
  }

  # New buckets have versioning disabled by default
  step "pipeline" "enable_s3_bucket_versioning" {
    if = step.pipeline.create_s3_bucket.stderr == ""
    pipeline = pipeline.update_s3_bucket_versioning
    args = {
     region            = param.region
     access_key_id     = param.access_key_id
     secret_access_key = param.secret_access_key
     bucket            = param.bucket
     versioning        = true
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  # The update command doesn't return the new state
  step "pipeline" "check_s3_bucket_versioning_enabled" {
    if = step.pipeline.enable_s3_bucket_versioning.stderr == ""
    pipeline = pipeline.get_s3_bucket_versioning
    args = {
     region            = param.region
     access_key_id     = param.access_key_id
     secret_access_key = param.secret_access_key
     bucket            = param.bucket
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "disable_s3_bucket_versioning" {
    if = step.pipeline.check_s3_bucket_versioning_enabled.stderr == ""
    pipeline = pipeline.update_s3_bucket_versioning
    args = {
     region            = param.region
     access_key_id     = param.access_key_id
     secret_access_key = param.secret_access_key
     bucket            = param.bucket
     versioning        = false
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  # The update command doesn't return the new state
  step "pipeline" "check_s3_bucket_versioning_disabled" {
    if = step.pipeline.disable_s3_bucket_versioning.stderr == ""
    pipeline = pipeline.get_s3_bucket_versioning
    args = {
     region            = param.region
     access_key_id     = param.access_key_id
     secret_access_key = param.secret_access_key
     bucket            = param.bucket
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_s3_bucket" {
    if = step.pipeline.create_s3_bucket.stderr == ""
    # Don't run before we've had a chance to list buckets
    depends_on = [step.pipeline.check_s3_bucket_versioning_disabled]

    pipeline = pipeline.delete_s3_bucket
    args = {
     region            = param.region
     access_key_id     = param.access_key_id
     secret_access_key = param.secret_access_key
     bucket            = param.bucket
    }
  }

  output "bucket" {
    description = "Bucket name used in the test."
    value = param.bucket
  }

  output "create_s3_bucket" {
    description = "Check for pipeline.create_s3_bucket."
    value       = step.pipeline.create_s3_bucket.stderr == "" ? "succeeded" : "failed: ${step.pipeline.create_s3_bucket.stderr}"
  }

  output "enable_s3_bucket_versioning" {
    description = "Check for pipeline.enable_s3_bucket_versioning."
    value       = step.pipeline.enable_s3_bucket_versioning.stderr == "" ? "succeeded" : "failed: ${step.pipeline.enable_s3_bucket_versioning.stderr}"
  }

  output "check_s3_bucket_versioning_enabled" {
    description = "Check for pipeline.check_s3_bucket_versioning_enabled."
    value       = step.pipeline.check_s3_bucket_versioning_enabled.stderr == "" && step.pipeline.check_s3_bucket_versioning_enabled.stdout.Status == "Enabled" ? "succeeded" : "failed: ${step.pipeline.check_s3_bucket_versioning_enabled.stderr}"
  }

  output "disable_s3_bucket_versioning" {
    description = "Check for pipeline.disable_s3_bucket_versioning."
    value       = step.pipeline.disable_s3_bucket_versioning.stderr == "" ? "succeeded" : "failed: ${step.pipeline.disable_s3_bucket_versioning.stderr}"
  }

  output "check_s3_bucket_versioning_disabled" {
    description = "Check for pipeline.check_s3_bucket_versioning_disabled."
    value       = step.pipeline.check_s3_bucket_versioning_disabled.stderr == "" && step.pipeline.check_s3_bucket_versioning_disabled.stdout.Status == "Suspended" ? "succeeded" : "failed: ${step.pipeline.check_s3_bucket_versioning_disabled.stderr}"
  }

  output "delete_s3_bucket" {
    description = "Check for pipeline.delete_s3_bucket."
    value       = step.pipeline.delete_s3_bucket.stderr == "" ? "succeeded" : "failed: ${step.pipeline.create_s3_bucket.stderr}"
  }

}
