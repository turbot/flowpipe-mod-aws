pipeline "generate_iam_credential_report" {
  title       = "Generate IAM Credential Report"
  description = "Generates the IAM Credential Report."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  step "container" "generate_iam_credential_report" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "iam",
      "generate-credential-report"
    ]
    env = param.conn.env
  }

  output "status" {
    description = "A structure with status details about the credentials report generates."
    value       = jsondecode(step.container.generate_iam_credential_report.stdout)
  }
}