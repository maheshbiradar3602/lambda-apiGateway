resource "aws_api_gateway_rest_api" "apiLambda" {
  name        = "azureCopytf"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}



resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
   path_part   = "azureCopy"
}

resource "aws_api_gateway_method" "proxyMethod" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "PUT" //check1 //PUT
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_method.proxyMethod.resource_id
   http_method = aws_api_gateway_method.proxyMethod.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.azure_lambda.invoke_arn
}




# resource "aws_api_gateway_method" "proxy_root" {
#    rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
#    resource_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
#    http_method   = "ANY"
#    authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "lambda_root" {
#    rest_api_id = aws_api_gateway_rest_api.apiLambda.id
#    resource_id = aws_api_gateway_method.proxy_root.resource_id
#    http_method = aws_api_gateway_method.proxy_root.http_method

#    integration_http_method = "POST"
#    type                    = "AWS_PROXY"
#    uri                     = aws_lambda_function.test_lambda.invoke_arn
# }


resource "aws_api_gateway_deployment" "apideploy" {
   depends_on = [
     aws_api_gateway_integration.lambda,
    # aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   stage_name  = "azureCopytf" 
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

resource "aws_api_gateway_usage_plan" "azurePlantf" {
  name = "azure_Plantf" 

  api_stages {
    api_id = aws_api_gateway_rest_api.apiLambda.id
    stage  = aws_api_gateway_deployment.apideploy.stage_name
  }
}

resource "aws_api_gateway_api_key" "azureKey" {
  name = "azure_key" 
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.azureKey.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.azurePlantf.id
}

output "base_url" {
  value = aws_api_gateway_deployment.apideploy.invoke_url
}