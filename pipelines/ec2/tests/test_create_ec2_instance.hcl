pipeline "test_create_ec2_instance" {
  title       = "Test Run EC2 Instance"
  description = "Test the run_ec2_instance pipeline."

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

  param "instance_type" {
    type        = string
    description = "The EC2 instance type (e.g., t2.micro)."
    default     = "t2.micro"
  }

  param "image_id" {
    type        = string
    description = "The ID of the Amazon Machine Image (AMI) to launch."
    default     = "ami-041feb57c611358bd"
  }

  step "pipeline" "run_ec2_instances" {
    pipeline = pipeline.run_ec2_instances
    args = {
     region            = param.region
     access_key_id     = param.access_key_id
     secret_access_key = param.secret_access_key
     instance_type     = param.instance_type
     image_id          = param.image_id
    }
  }

  // # There is no get_s3_bucket pipeline, so use list instead
  // step "pipeline" "list_s3_buckets" {
  //   if = step.pipeline.run_ec2_instances.stderr == ""
  //   pipeline = pipeline.list_s3_buckets
  //   args = {
  //    region            = param.region
  //    access_key_id     = param.access_key_id
  //    secret_access_key = param.secret_access_key
  //   }

  //   # Ignore errors so we can delete
  //   error {
  //     ignore = true
  //   }
  // }

  // step "pipeline" "terminate_ec2_instances" {
  //   if = step.pipeline.run_ec2_instances.stderr == ""
  //   # Don't run before we've had a chance to list buckets
  //   depends_on = [step.pipeline.list_s3_buckets]

  //   pipeline = pipeline.terminate_ec2_instances
  //   args = {
  //    region            = param.region
  //    access_key_id     = param.access_key_id
  //    secret_access_key = param.secret_access_key
  //    instance_ids      = param.bucket
  //   }
  // }

  output "created_instance_id" {
    description = "Check for pipeline.run_ec2_instances."
    value       = step.pipeline.run_ec2_instances.stdout.Instances[0].InstanceId
  }

  output "run_ec2_instances" {
    description = "Check for pipeline.run_ec2_instances."
    value       = step.pipeline.run_ec2_instances.stderr == "" ? "succeeded" : "failed: ${step.pipeline.run_ec2_instances.stderr}"
  }

  // output "list_s3_buckets" {
  //   description = "Check for pipeline.list_s3_buckets."
  //   value       = step.pipeline.list_s3_buckets.stderr == "" && length([for bucket in step.pipeline.list_s3_buckets.stdout.Buckets : bucket if bucket.Name == param.bucket]) > 0  ? "succeeded" : "failed: ${step.pipeline.list_s3_buckets.stderr}"
  // }

  // output "terminate_ec2_instances" {
  //   description = "Check for pipeline.terminate_ec2_instances."
  //   value       = step.pipeline.terminate_ec2_instances.stderr == "" ? "succeeded" : "failed: ${step.pipeline.run_ec2_instances.stderr}"
  // }

}
