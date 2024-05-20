pipeline "enabled_xray_tracing_apigateway_rest_api_stage" {
  title       = "Enable API Gateway REST API stage X-Ray tracing"
  description = "Enable X-Ray tracing for API Gateway REST API stage."

  param "region" {
    type        = string
    description = local.region_param_description
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "aws_profile"
  }

  param "rest_api_id" {
    type        = string
    description = "The REST API id of API Gateway."
  }

  param "stage_name" {
    type        = string
    description = "The stage name of API Gateway."
  }

  step "container" "enabled_xray_tracing_apigateway_rest_api_stage" {
    image = "public.ecr.aws/aws-cli/aws-cli"

    cmd = [
        "apigateway", "update-stage",
        "--rest-api-id", param.rest_api_id,
        "--stage-name", param.stage_name,
        "--patch-operations", "op=replace,path=/tracingEnabled,value=true",
      ]

    env = merge(credential.aws[param.cred].env, { AWS_REGION = param.region })
  }
}
