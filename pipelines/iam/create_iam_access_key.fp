pipeline "create_iam_access_key" {
  title       = "Create IAM Access Key"
  description = "Creates a new AWS access key and secret for an IAM user."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "user_name" {
    type        = string
    description = "The name of the IAM user to create the access key for."
  }

  step "container" "create_access_key" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "iam",
      "create-access-key",
      "--user-name", "${param.user_name}"
    ]
    env = param.conn.env
  }

  output "access_key" {
    description = "A structure with details about the new Access Keys."
    value       = jsondecode(step.container.create_access_key.stdout).AccessKey
  }

}
