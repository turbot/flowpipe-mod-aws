pipeline "create_iam_user" {
  title       = "Create IAM User"
  description = "Creates an IAM user with the given name."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "user_name" {
    description = "The name of the user to create."
    type        = string
  }

  step "container" "create_user" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "iam",
      "create-user",
      "--user-name", param.user_name
    ]
    env = param.conn.env
  }

  output "user" {
    description = "A structure with details about the new IAM user."
    value       = jsondecode(step.container.create_user.stdout).User
  }
}
