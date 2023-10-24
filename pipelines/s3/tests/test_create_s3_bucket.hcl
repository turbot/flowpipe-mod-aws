pipeline "test_create_s3_bucket" {
  title       = "Test Create S3 Bucket"
  description = "Test the create_s3_bucket pipeline."

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

  # TODO: Handle regions better and use --create-bucket-configuration
  step "pipeline" "create_s3_bucket" {
    pipeline = pipeline.create_s3_bucket
    args = {
     # TODO: Handle regions better and use --create-bucket-configuration
     #region            = param.region
     access_key_id     = param.access_key_id
     secret_access_key = param.secret_access_key
     bucket              = param.bucket
    }
  }

  # There is no get_s3_bucket pipeline, so use list instead
  step "pipeline" "list_s3_buckets" {
    if = step.pipeline.create_s3_bucket.stderr == ""
    pipeline = pipeline.list_s3_buckets
    args = {
     region            = param.region
     access_key_id     = param.access_key_id
     secret_access_key = param.secret_access_key
    }

    # Ignore errors so we always delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_s3_bucket" {
    if = step.pipeline.create_s3_bucket.stderr == ""
    # Don't run before we've had a chance to list buckets
    depends_on = [step.pipeline.list_s3_buckets]

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
    value       = step.pipeline.create_s3_bucket.stderr == "" ? "pass" : "fail: ${step.pipeline.create_s3_bucket.stderr}"
  }

  output "list_s3_buckets" {
    description = "Check for pipeline.list_s3_buckets."
    value       = step.pipeline.list_s3_buckets.stderr == "" && length([for bucket in step.pipeline.list_s3_buckets.stdout.Buckets : bucket if bucket.Name == param.bucket]) > 0  ? "pass" : "fail: ${step.pipeline.list_s3_buckets.stderr}"
  }

  output "delete_s3_bucket" {
    description = "Check for pipeline.delete_s3_bucket."
    value       = step.pipeline.delete_s3_bucket.stderr == "" ? "pass" : "fail: ${step.pipeline.create_s3_bucket.stderr}"
  }

}
