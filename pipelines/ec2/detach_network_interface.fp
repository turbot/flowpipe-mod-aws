pipeline "detach_network_interface" {
  title       = "Detach Network Interface"
  description = "Detaches a specified network interface from an instance by using its attachment ID."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "attachment_id" {
    type        = string
    description = "The attachment ID of the network interface. This ID uniquely identifies the connection between the network interface and the instance."
  }

  param "force_detach" {
    type        = bool
    description = "Forcefully detach the network interface."
    default     = true
    optional    = true
  }

  step "container" "detach_interface" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      [
        "ec2", "detach-network-interface",
        "--attachment-id", param.attachment_id
      ],
      param.force_detach ? ["--force"] : []
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "operation_status" {
    description = "Details about the network interface detachment operation."
    value       = "Network interface with attachment ID ${param.attachment_id} detached successfully."
  }
}
