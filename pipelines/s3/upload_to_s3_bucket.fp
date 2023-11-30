pipeline "upload_to_s3_bucket" {
  title       = "Upload to S3 Bucket"
  description = "Upload a local file to an Amazon S3 bucket."

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
    description = "The name of the S3 bucket."
    default     = "sourav-test-bucket"
  }

  param "key" {
    type        = string
    description = "The object key in S3 (effectively the name of the file in the bucket)."
    default     = "test.csv"
  }

  param "body" {
    type        = string
    description = "The local file path for the file you're uploading."
    default     = "/Users/sourav/Downloads/addresses.csv"
  }

  step "transform" "file_content" {
    value = file(param.body)
  }

  // echo "test" > file.$ (basename / Users / sourav / Downloads / addresses.csv | cut - d.- f2)


  step "container" "file_content" {
    depends_on = [step.transform.file_content]
    image      = "public.ecr.aws/aws-cli/aws-cli"
    cmd        = ["-c", "echo '${step.transform.file_content.value}' > file.$(basename ${param.body} | cut -d. -f2) && cat file.$(basename ${param.body} | cut -d. -f2) && aws s3api put-object --bucket ${param.bucket} --key ${param.key} --body file.$(basename ${param.body} | cut -d. -f2)"]
    entrypoint = ["/bin/sh"]
    env = {
      AWS_REGION            = param.region
      AWS_ACCESS_KEY_ID     = param.access_key_id
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  // step "container" "upload_to_s3_bucket" {
  //   image = "public.ecr.aws/aws-cli/aws-cli"

  //   cmd = concat(
  //     ["s3api", "put-object"],
  //     ["--bucket", param.bucket],
  //     ["--key", param.key],
  //     ["--body", file(param.body)],
  //   )

  //   env = {
  //     AWS_REGION            = param.region
  //     AWS_ACCESS_KEY_ID     = param.access_key_id
  //     AWS_SECRET_ACCESS_KEY = param.secret_access_key
  //   }
  // }

  output "echo" {
    value = step.container.file_content
  }
}
