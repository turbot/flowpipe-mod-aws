pipeline "modify_client_vpn_endpoint" {
  title       = "Modify Client VPN Endpoint"
  description = "Modifies the connection log settings of a specified AWS Client VPN endpoint."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "client_vpn_endpoint_id" {
    type        = string
    description = "The ID of the Client VPN endpoint to modify."
  }

  param "enable_logging" {
    type        = bool
    description = "Enable or disable logging of VPN connections."
    default     = true
  }

  param "cloudwatch_log_group" {
    type        = string
    description = "The name of the CloudWatch Log Group to log VPN connections."
    optional    = true
  }

  param "cloudwatch_log_stream" {
    type        = string
    description = "The name of the CloudWatch Log Stream within the Log Group."
    optional    = true
  }

  step "container" "modify_vpn_endpoint" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = concat(
      [
        "ec2", "modify-client-vpn-endpoint",
        "--client-vpn-endpoint-id", param.client_vpn_endpoint_id,
        "--connection-log-options", jsonencode({
          "Enabled": param.enable_logging,
          "CloudwatchLogGroup": param.cloudwatch_log_group,
          "CloudwatchLogStream": param.cloudwatch_log_stream
        })
      ]
    )

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "vpn_modification" {
    description = "Details about the VPN endpoint modification."
    value       = "Client VPN Endpoint ID ${param.client_vpn_endpoint_id} modified successfully."
  }
}
