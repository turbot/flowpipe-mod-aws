pipeline "get_ebs_encryption_by_default" {
  title       = "Get EBS Encryption by Default"
  description = "Describes whether EBS encryption by default is enabled for your account in the current Region."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  step "container" "get_ebs_encryption_by_default" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "ec2", "get-ebs-encryption-by-default"
    ]
    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "ebs_encryption_by_default" {
    description = "Indicates whether encryption by default is enabled."
    value       = step.container.get_ebs_encryption_by_default.stdout
  }
}
