pipeline "modify_apigateway_rest_api_stage" {
  title       = "Modify API Gateway REST API stage"
  description = "Modifies settings for API Gateway REST API stage."

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
    description = "The REST API ID of API Gateway."
  }

  param "stage_name" {
    type        = string
    description = "The stage name of API Gateway REST API."
  }

  step "container" "modify_apigateway_rest_api_stage" {
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
