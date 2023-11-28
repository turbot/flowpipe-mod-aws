# TODO: Do steps need to check stderr/is_error() or should they use depends_on?
pipeline "test_create_s3_bucket" {
  title       = "Test Create S3 Bucket"
  description = "Test the create_s3_bucket pipeline."

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

  # There is no get_s3_bucket pipeline, so use list instead
  step "pipeline" "list_s3_buckets" {
    if = step.pipeline.create_s3_bucket.output.stderr == ""

    pipeline = pipeline.list_s3_buckets
    args = {
     region            = param.region
     access_key_id     = param.access_key_id
     secret_access_key = param.secret_access_key
    }

    # Ignore errors so we can always delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_s3_bucket" {
    if = step.pipeline.create_s3_bucket.output.stderr == ""
    # Don't run before we've had a chance to list buckets
    depends_on = [step.pipeline.list_s3_buckets]

    pipeline = pipeline.delete_s3_bucket
    args     = step.echo.base_args.output.base_args
  }

  # TODO: What would an assert step type look like?
  /*
  step "assert" "create_s3_bucket_check" {
    if = step.pipeline.create_s3_bucket.output.stderr != ""
    message = step.pipeline.create_s3_bucket.output.stderr
  }
  */

  output "bucket" {
    description = "Bucket name used in the test."
    value = param.bucket
  }

  output "test_results" {
    description = "Test results for each step."
    value       = {
      # TODO: Switch to use is_error() once supported for container steps
      #"create_s3_bucket" = !is_error(step.pipeline.create_s3_bucket) ? "pass" : "fail: ${step.pipeline.create_s3_bucket.errors}"
      #"list_s3_buckets"  = !is_error(step.pipeline.list_s3_buckets) && length([for bucket in step.pipeline.list_s3_buckets.output.buckets : bucket if bucket.Name == param.bucket]) > 0  ? "pass" : "fail: ${step.pipeline.list_s3_buckets.errors}"
      #"delete_s3_bucket" = !is_error(step.pipeline.delete_s3_bucket) ? "pass" : "fail: ${step.pipeline.create_s3_bucket.errors}"

      "create_s3_bucket" = step.pipeline.create_s3_bucket.output.stderr == "" ? "pass" : "fail: ${step.pipeline.create_s3_bucket.output.stderr}"
      "list_s3_buckets"  = step.pipeline.list_s3_buckets.output.stderr == "" && length([for bucket in step.pipeline.list_s3_buckets.output.buckets : bucket if bucket.Name == param.bucket]) > 0  ? "pass" : "fail: ${step.pipeline.list_s3_buckets.output.stderr}"
      "delete_s3_bucket" = step.pipeline.delete_s3_bucket.output.stderr == "" ? "pass" : "fail: ${step.pipeline.create_s3_bucket.output.stderr}"
    }
  }

}
