resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_name}"
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:us-east-1:123456789012:example1234/*/*/*/*"
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 7
}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_function_name
  s3_bucket     = "app-inbound-ai-lambda"
  s3_key        = "lambda.zip"
  handler       = "MyLambdaProject::MyLambdaProject.LambdaEntryPoint::FunctionHandlerAsync"  
  runtime       = "dotnet8"
  memory_size   = 256
  timeout       = 30
  source_code_hash = data.aws_s3_object.lambda_zip.etag

  logging_config {
    log_group  = aws_cloudwatch_log_group.lambda_log_group.name
    log_format = "JSON"
  }

  environment {
    variables = {
      "ENVIRONMENT" = "Production"
    }
  }

  role = aws_iam_role.lambda_role.arn

  depends_on = [
    aws_iam_role.lambda_role,
  ]
}