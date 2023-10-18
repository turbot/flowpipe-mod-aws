pipeline "run_ec2_instances" {
  title       = "Launch EC2 Instance"
  description = "Launches an Amazon EC2 instance."

  param "region" {
    type        = string
    description = "The name of the Region."
    default     = var.region
  }

  param "access_key_id" {
    type        = string
    description = "The ID for this access key."
    default     = var.access_key_id
  }

  param "secret_access_key" {
    type        = string
    description = "The secret key used to sign requests."
    default     = var.secret_access_key
  }

  param "instance_type" {
    type        = string
    description = "The EC2 instance type (e.g., t2.micro)."
  }

  param "image_id" {
    type        = string
    description = "The ID of the Amazon Machine Image (AMI) to launch."
  }

  step "container" "run_ec2_instances" {
    image = "amazon/aws-cli"

    cmd = [
      "ec2", "run-instances",
      // "--region", param.region,
      "--instance-type", param.instance_type,
      "--image-id", param.image_id
    ]

    env = {
      AWS_REGION            = param.region,
      AWS_ACCESS_KEY_ID     = param.access_key_id,
      AWS_SECRET_ACCESS_KEY = param.secret_access_key
    }
  }

  output "stdout" {
    description = "The JSON output from the AWS CLI."
    value       = jsondecode(step.container.run_ec2_instances.stdout)
  }

  output "stderr" {
    description = "The error output from the AWS CLI."
    value       = step.container.run_ec2_instances.stderr
  }
}
