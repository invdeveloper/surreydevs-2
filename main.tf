##
##  Setup the AWS Region
##
variable "aws_region" {
  default     = "eu-west-2"
  description = "AWS Region to host S3 site"
  type        = string
}

##
## This part sets up Localstack as the AWS provider which
## allows us to run terrafrom against it, note we have a 
## definition for each of the services we ant to use.
##
provider "aws" {
  region          = "${var.aws_region}"
  access_key                  = "access_key"
  secret_key                  = "secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style = true
  
  endpoints {
    apigateway     = "http://localhost:4566"
    cloudwatchlogs = "http://localhost:4566"
    events         = "http://localhost:4566"
    iam            = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    s3             = "http://localhost:4566"
  }
}


##
## This is the test lambda function
##
resource "aws_lambda_function" "test_lambda" {
  function_name = "test_lambda"
  handler = "test.handler"
  role = aws_iam_policy.test_lambda.arn
  runtime = "nodejs16.x"

  filename = "${path.module}/lambda_function/dist/test-lambda.zip"

  timeout = 30
  memory_size = 128

  environment {
    variables = {
      LOCALSTACK_ENABLED = true
    }
  }
}

