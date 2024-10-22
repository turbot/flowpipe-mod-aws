pipeline "delete_iam_server_certificate" {
  title       = "Delete IAM Server Certificate"
  description = "Deletes the specified server certificate from AWS IAM."

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "server_certificate_name" {
    type        = string
    description = "The name of the server certificate you want to delete."
  }

  step "container" "delete_server_certificate" {
    image = "public.ecr.aws/aws-cli/aws-cli"
    cmd = [
      "iam", "delete-server-certificate",
      "--server-certificate-name", param.server_certificate_name
    ]

    env = param.conn.env
  }
}
