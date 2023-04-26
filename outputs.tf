output "api_gateway_base_url" {
  value = aws_api_gateway_deployment.apideploy.invoke_url
}

output "localstack_api_gateway_base_url" {
  value = "http://localhost:4566/restapis/${aws_api_gateway_deployment.apideploy.rest_api_id}/${aws_api_gateway_deployment.apideploy.stage_name}/_user_request_/${aws_api_gateway_rest_api.test_lambda.name}"
}