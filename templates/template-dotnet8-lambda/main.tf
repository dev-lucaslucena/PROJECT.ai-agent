resource "aws_security_group" "app-inbound-ai-lambda" {
  name        = "${var.lambda_function_name}-sg"
  description = "Security group for ${var.lambda_function_name} Lambda"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 7
}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_function_name
  s3_bucket     = ""
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

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [aws_security_group.app-inbound-ai-lambda.id]
  }

  environment {
    variables = {
      "ENVIRONMENT" = "Production"
    }
  }

  role = aws_iam_role.lambda_role.arn

  depends_on = [
    aws_iam_role.lambda_role,
    aws_security_group.app-inbound-ai-lambda
  ]
}