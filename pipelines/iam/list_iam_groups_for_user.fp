pipeline "list_iam_groups_for_user" {
  title       = "List IAM Groups for User"
  description = "Lists the IAM groups that the specified IAM user belongs to."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
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

    env = param.conn.env
  }

  output "groups" {
    description = "A list of groups."
    value       = jsondecode(step.container.list_groups_for_user.stdout).Groups
  }
}
