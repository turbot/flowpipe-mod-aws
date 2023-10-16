pipeline "start_ec2_instance" {
    param "instance_id" {
        type = string
    }
    step "container" "container_run_aws" {
        image = "amazon/aws-cli"
        cmd = ["ec2", "start-instances", "--instance-ids", param.instance_id]
        env = {
            AWS_REGION            = var.aws_region
            AWS_ACCESS_KEY_ID     = var.aws_access_key_id
            AWS_SECRET_ACCESS_KEY = var.aws_secret_access_key
        }
    }
    output "stdout_aws" {
        value = step.container.container_run_aws.stdout
    }
     output "stderr_aws" {
        value = step.container.container_run_aws.stderr
    }
}
