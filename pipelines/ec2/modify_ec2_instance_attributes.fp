pipeline "modify_ec2_instance_attributes" {
  title       = "Modify EC2 Instance Attributes"
  description = "Modify attributes of an EC2 instance in AWS."

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

  param "instance_id" {
    type        = string
    description = "ID of the EC2 instance to modify."
  }

  param "security_group_ids" {
    type        = list(string)
    description = "IDs of the new security groups to associate with the instance."
    optional    = true
  }

  step "container" "modify_ec2_instance_attributes" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      ["ec2", "modify-instance-attribute"],
      ["--instance-id", param.instance_id],
      param.security_group_ids != null ? ["--groups", join(",", param.security_group_ids)] : [],
    )

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }
}
