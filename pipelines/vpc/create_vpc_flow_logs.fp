pipeline "create_vpc_flow_logs" {
  title       = "Create VPC Flow Logs"
  description = "Sets up flow logs for a specified VPC to monitor its network traffic."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "conn" {
    type        = connection.aws
    description = local.conn_param_description
    default     = connection.aws.default
  }

  param "vpc_id" {
    type        = string
    description = "The ID of the VPC for which to enable flow logs."
  }

  param "log_group_name" {
    type        = string
    description = "The name of the CloudWatch Logs log group where the flow logs will be stored."
  }

  param "traffic_type" {
    type        = string
    description = "The type of traffic to log. Valid values are 'ACCEPT', 'REJECT', or 'ALL'."
    default     = "ALL"
  }

  param "iam_role_arn" {
    type        = string
    description = "The ARN of the IAM role that has permission to create flow logs."
  }

  step "container" "setup_vpc_flow_logs" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
      "ec2", "create-flow-logs",
      "--resource-type", "VPC",
      "--resource-ids", param.vpc_id,
      "--traffic-type", param.traffic_type,
      "--log-destination-type", "cloud-watch-logs",
      "--log-group-name", param.log_group_name,
      "--deliver-logs-permission-arn", param.iam_role_arn
    ]

    env = merge(param.conn.env, { AWS_REGION = param.region })
  }

  output "flow_log_creation" {
    description = "Details about the creation of VPC flow logs."
    value       = "Flow logs for VPC ${param.vpc_id} have been successfully created and configured to log ${param.traffic_type} traffic."
  }
}
