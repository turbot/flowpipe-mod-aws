pipeline "create_iam_access_key" {
  title = "Create IAM Access Key"
  description = "Creates a new AWS access key and secret for an IAM user."

  tags = {
    type = "featured",
  }

  param "cred" {
    type = string
    default = "default"
  }

  param "user_name" {
    type = string
    description = "The name of the IAM user to create the access key for."
  }

  step "container" "create_access_key" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "iam",
      "create-access-key",
      "--user-name", "${param.user_name}"
    ]
    env = credential.aws[param.cred].env
  }

  output "access_key" {
    value = jsondecode(step.container.create_access_key.stdout).AccessKey
  }

}
