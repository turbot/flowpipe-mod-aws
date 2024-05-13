pipeline "put_s3_bucket_lifecycle_policy" {
  title       = "Put S3 Bucket Lifecycle Policy"
  description = "Puts a lifecycle policy to a specified S3 bucket."

  param "region" {
    type        = string
    description = "The AWS region where the S3 bucket is located."
    default     = "ap-south-1"
  }

  param "cred" {
    type        = string
    description = "AWS credentials for authentication."
    default     = "default"
  }

  param "bucket_name" {
    type        = string
    description = "The name of the S3 bucket."
    default     = "ved-bucket-test"
  }

  param "lifecycle_policies" {
    type = list(object({
      ID     = optional(string)
      Prefix = optional(string)
      Status = string
      Transitions = optional(list(object({
        Date         = optional(string)
        Days         = optional(number)
        StorageClass = string
      })))
      Expiration = optional(object({
        Date                      = optional(string)
        Days                      = optional(number)
        ExpiredObjectDeleteMarker = optional(bool)
      }))
      AbortIncompleteMultipartUpload = optional(object({
        DaysAfterInitiation = optional(number)
      }))
    }))
    description = "A list of lifecycle policies for the S3 bucket."
    default = [
      {
        ID     = " TransitionToIA ",
        Status = " Enabled ",
        Transitions = [
          {
            Days         = 30,
            StorageClass = " STANDARD_IA "
          }
        ],
        Expiration = {
          Days = 365
        }
      },
      {
        ID     = " ExpireOldVersions ",
        Prefix = " ",
        Status = " Enabled ",
        Expiration = {
          Days = 180
        },
        AbortIncompleteMultipartUpload = {
          DaysAfterInitiation = 7
        }
      }
    ]
  }

  step "container" "put_s3_bucket_lifecycle_policy" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["s3api", "put-bucket-lifecycle-configuration"],
      ["--bucket", param.bucket_name],
      ["--lifecycle-configuration", jsonencode({
        Rules = param.lifecycle_policies
      })]
    )

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }

  output "rules" {
    description = "Contains the details of the lifecycle policy put request."
    value       = jsondecode(step.container.put_s3_bucket_lifecycle_policy.stdout).Rules
  }
}