pipeline "test_update_s3_bucket_versioning" {
  title       = "Test Update S3 Bucket Versioning"
  description = "Test the update_s3_bucket_versioning pipeline."

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

  param "name" {
    type        = string
    description = "The name of the bucket."
    default     = "flowpipe-test-bucket-${uuid()}"
  }

  step "pipeline" "create_s3_bucket" {
    pipeline = pipeline.create_s3_bucket
    args = {
     region            = param.region
     access_key_id     = param.access_key_id
     secret_access_key = param.secret_access_key
     name              = param.name
    }
  }

  step "pipeline" "enable_s3_bucket_versioning" {
    if = step.pipeline.create_s3_bucket.stderr == ""
    pipeline = pipeline.update_s3_bucket_versioning
    args = {
     region            = param.region
     access_key_id     = param.access_key_id
     secret_access_key = param.secret_access_key
     name              = param.name
     versioning        = true
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "disable_s3_bucket_versioning" {
    if = step.pipeline.enable_s3_bucket_versioning.stderr == ""
    pipeline = pipeline.update_s3_bucket_versioning
    args = {
     region            = param.region
     access_key_id     = param.access_key_id
     secret_access_key = param.secret_access_key
     name              = param.name
     versioning        = false
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }


  step "pipeline" "delete_s3_bucket" {
    if = step.pipeline.create_s3_bucket.stderr == ""
    # Don't run before we've had a chance to list buckets
    depends_on = [step.pipeline.disable_s3_bucket_versioning]

    pipeline = pipeline.delete_s3_bucket
    args = {
     region            = param.region
     access_key_id     = param.access_key_id
     secret_access_key = param.secret_access_key
     name              = param.name
    }
  }

  output "bucket_name" {
    description = "Bucket name used in the test."
    value = param.name
  }

  output "create_s3_bucket" {
    description = "Check for pipeline.create_s3_bucket."
    value       = step.pipeline.create_s3_bucket.stderr == "" ? "succeeded" : "failed: ${step.pipeline.create_s3_bucket.stderr}"
  }

  output "enable_s3_bucket_versioning" {
    description = "Check for pipeline.enable_s3_bucket_versioning."
    value       = step.pipeline.enable_s3_bucket_versioning.stderr == "" ? "succeeded" : "failed: ${step.pipeline.enable_s3_bucket_versioning.stderr}"
  }

  output "disable_s3_bucket_versioning" {
    description = "Check for pipeline.disable_s3_bucket_versioning."
    value       = step.pipeline.disable_s3_bucket_versioning.stderr == "" ? "succeeded" : "failed: ${step.pipeline.disable_s3_bucket_versioning.stderr}"
  }

  output "delete_s3_bucket" {
    description = "Check for pipeline.delete_s3_bucket."
    value       = step.pipeline.delete_s3_bucket.stderr == "" ? "succeeded" : "failed: ${step.pipeline.create_s3_bucket.stderr}"
  }

}
