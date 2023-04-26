##
## Manages an API Gateway REST API. 
##
resource "aws_api_gateway_rest_api" "test_lambda" {
  name          = "registration_api"
}

##
## Provides an API Gateway Resource.
##
resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.test_lambda.id
   parent_id   = aws_api_gateway_rest_api.test_lambda.root_resource_id
   path_part   = "{proxy+}"
}

##
## Provides a HTTP Method for an API Gateway Resource.
##
resource "aws_api_gateway_method" "proxyMethod" {
   rest_api_id   = aws_api_gateway_rest_api.test_lambda.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

##
## Provides an HTTP Method Integration for an API Gateway Integration.
##
resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.test_lambda.id
   resource_id = aws_api_gateway_method.proxyMethod.resource_id
   http_method = aws_api_gateway_method.proxyMethod.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.test_lambda.invoke_arn
}

##
## Provides a HTTP Method for an API Gateway Resource.
##
resource "aws_api_gateway_method" "proxy_root" {
   rest_api_id   = aws_api_gateway_rest_api.test_lambda.id
   resource_id   = aws_api_gateway_rest_api.test_lambda.root_resource_id
   http_method   = "ANY"
   authorization = "NONE"
}

##
## Provides an HTTP Method Integration for an API Gateway Integration.
##
resource "aws_api_gateway_integration" "lambda_root" {
   rest_api_id = aws_api_gateway_rest_api.test_lambda.id
   resource_id = aws_api_gateway_method.proxy_root.resource_id
   http_method = aws_api_gateway_method.proxy_root.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.test_lambda.invoke_arn
}

##
## Manages an API Gateway REST Deployment
##
resource "aws_api_gateway_deployment" "apideploy" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.test_lambda.id
   stage_name  = "test"
}

##
## Gives an external source (like an EventBridge Rule, SNS, or S3) 
## permission to access the Lambda function.
##
resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.test_lambda.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.test_lambda.execution_arn}/*/*"
}


