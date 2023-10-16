pipeline "modify_rds_db_instance" {

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

    param "instance_identifier" {
      type        = string
      description = "The instance ID."
      optional    = true
    }

    param "publicly_accessible" {
      type        = bool
      description = "Whether the DB instance is publicly accessible."
      optional    = true
    }

    step "container" "modify_rds_db_instance" {
      image = "amazon/aws-cli"

      cmd = concat(
        ["rds", "modify-db-instance", "--apply-immediately", "--db-instance-identifier", param.instance_identifier],
        param.publicly_accessible != null ? param.publicly_accessible ? ["--publicly-accessible"] : ["--no-publicly-accessible"] : [],
      )

      env = {
        AWS_REGION            = param.region
        AWS_ACCESS_KEY_ID     = param.access_key_id
        AWS_SECRET_ACCESS_KEY = param.secret_access_key
      }
    }

    output "stdout" {
      value = jsondecode(step.container.modify_rds_db_instance.stdout)
    }

    output "stderr" {
      value = jsondecode(step.container.modify_rds_db_instance.stderr)
    }
}
