resource "aws_api_gateway_rest_api" "apiLambda" {
  name        = var.api_gw_rest_name

  endpoint_configuration {
    types = [ var.api_gw_endpoint_confg ]
  }
}


resource "aws_api_gateway_resource" "apiLambdaResource" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
   path_part   = var.api_gw_resource_path_part
}

resource "aws_api_gateway_method" "apiLambdaMethod" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.apiLambdaResource.id
   http_method   = var.api_gw_method_http_method
   authorization = var.api_gw_method_http_authorization
   api_key_required = var.api_gw_method_http_key_required
   operation_name = "aws_api_gateway_deployment.apideploy.invoke_url"
}

resource "aws_api_gateway_integration" "apiLambdaIntegration" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_method.apiLambdaMethod.resource_id
   http_method = aws_api_gateway_method.apiLambdaMethod.http_method

   integration_http_method = var.api_gw_inegration_http_method
   type                    = var.api_gw_inegration_type
   uri                     = aws_lambda_function.azure_lambda.invoke_arn
}




resource "aws_api_gateway_deployment" "apideploy" {
   depends_on = [
     aws_api_gateway_integration.apiLambdaIntegration,
    # aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   stage_name  = var.api_gw_deployment_stage_name
}

resource "aws_api_gateway_method_response" "apiLambdaMethodResponse" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  resource_id = aws_api_gateway_method.apiLambdaMethod.resource_id
  http_method = aws_api_gateway_method.apiLambdaMethod.http_method
  status_code = var.api_gw_method_response_status_code
   response_models     = {
          - application/json: "Empty"
    }
}


resource "aws_api_gateway_integration_response" "apiLambdaIntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_method.apiLambdaMethod.resource_id
   http_method = aws_api_gateway_method.apiLambdaMethod.http_method
   status_code = aws_api_gateway_method_response.apiLambdaMethodResponse.status_code

     depends_on = [
    aws_api_gateway_integration.apiLambdaIntegration
  ]
 }

resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.azure_lambda.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/*/*"
}
#test

resource "aws_api_gateway_usage_plan" "azurePlantf" {
  name = var.api_gw_usage_plan_name

  api_stages {
    api_id = aws_api_gateway_rest_api.apiLambda.id
    stage  = aws_api_gateway_deployment.apideploy.stage_name
  }
}

resource "aws_api_gateway_api_key" "azureKey" {
  name = var.api_gw_api_key
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.azureKey.id
  key_type      = var.api_gw_usage_plan_key_type
  usage_plan_id = aws_api_gateway_usage_plan.azurePlantf.id
}

output "base_url" {
  value = aws_api_gateway_deployment.apideploy.invoke_url
}