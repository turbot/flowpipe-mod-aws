pipeline "list_iam_groups_for_user" {
  title       = "List IAM Groups for User"
  description = "Lists the IAM groups that the specified IAM user belongs to."

  tags = {
    type = "featured"
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "user_name" {
    type        = string
    description = "The name of the user to list groups for."
  }

  step "container" "list_groups_for_user" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "iam", "list-groups-for-user",
      "--user-name", param.user_name
    ]

    env = credential.aws[param.cred].env
  }

  output "groups" {
    description = "A list of groups."
    value       = jsondecode(step.container.list_groups_for_user.stdout).Groups
  }
}
