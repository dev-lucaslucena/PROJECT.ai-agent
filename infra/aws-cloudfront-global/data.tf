data "aws_apigatewayv2_api" "apigtw_global" {
  api_id = "example1234"
}

data "aws_lambda_function" "lambda" {
  function_name = "cloudfront-edgelambda-global"
}

data "aws_caller_identity" "current" {}

data "aws_cloudfront_cache_policy" "default" {
  id = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
}

data "aws_cloudfront_origin_request_policy" "default" {
  id = "b689b0a8-53d0-40ab-baf2-68738e2966ac"
}

data "aws_cloudfront_response_headers_policy" "default" {
  id = "60669652-455b-4ae9-85a4-c4c02393f86c"
}