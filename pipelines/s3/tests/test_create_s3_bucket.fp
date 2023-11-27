pipeline "test_create_s3_bucket" {
  title       = "Test Create S3 Bucket"
  description = "Test the create_s3_bucket pipeline."

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

  param "region" {
    type        = string
    description = local.region_param_description
    default     = var.region
  }

  param "bucket" {
    type        = string
    description = "The name of the bucket."
    default     = "flowpipe-test-${uuid()}"
  }

  step "transform" "base_args" {
    output "base_args" {
      value = {
        access_key_id     = param.access_key_id
        bucket            = param.bucket
        region            = param.region
        secret_access_key = param.secret_access_key
      }
    }
  }

  step "pipeline" "create_s3_bucket" {
    pipeline = pipeline.create_s3_bucket
    args     = step.transform.base_args.output.base_args
  }

  # There is no get_s3_bucket pipeline, so use list instead
  step "pipeline" "list_s3_buckets" {
    depends_on = [step.pipeline.create_s3_bucket]

    pipeline = pipeline.list_s3_buckets
    args = {
      # TODO: Revert after testing failures
     #region            = param.region
     region            = "us-yyy-3"
     access_key_id     = param.access_key_id
     secret_access_key = param.secret_access_key
    }

    # Ignore errors so we can always delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_s3_bucket" {
    # Don't run before we've had a chance to list buckets
    depends_on = [step.pipeline.list_s3_buckets]

    pipeline = pipeline.delete_s3_bucket
    args     = step.transform.base_args.output.base_args
  }

  output "bucket" {
    description = "Bucket name used in the test."
    value = param.bucket
  }

  output "test_results" {
    description = "Test results for each step."
    value       = {
      "create_s3_bucket" = !is_error(step.pipeline.create_s3_bucket) ? "pass" : "fail: ${error_message(step.pipeline.create_s3_bucket)}"
      "list_s3_buckets"  = !is_error(step.pipeline.list_s3_buckets) && length([for bucket in try(step.pipeline.list_s3_buckets.output.buckets, []) : bucket if bucket.Name == param.bucket]) > 0  ? "pass" : "fail: ${error_message(step.pipeline.list_s3_buckets)}"
      "delete_s3_bucket" = !is_error(step.pipeline.delete_s3_bucket) ? "pass" : "fail: ${error_message(step.pipeline.create_s3_bucket)}"
    }
  }

}
