resource "aws_s3_bucket" "airealtimedatingcoach-serverlessapi-lambda" {
  bucket = "template-dotnet8-lambda"
  force_destroy = true
}

resource "aws_s3_bucket" "app-inbound-ai-lambda" {
  bucket = "app-inbound-ai-lambda"
  force_destroy = true
}

resource "aws_s3_bucket" "app-process-bestai-lambda" {
  bucket = "app-process-bestai-lambda"
  force_destroy = true
}

resource "aws_s3_bucket" "app-process-openaichatgpt-lambda" {
  bucket = "app-process-openaichatgpt-lambda"
  force_destroy = true
}

resource "aws_s3_bucket" "aws-edgelambda-global" {
  bucket = "aws-edgelambda-global"
  force_destroy = true
}       

resource "aws_s3_bucket" "aws-authorizerlambda-apigtw-global" {
  bucket = "aws-authorizerlambda-apigtw-global"
  force_destroy = true
}       

resource "aws_s3_bucket" "aws-rotationlambda-global-apigtw-cloudfront-secret" {
  bucket = "aws-rotationlambda-global-apigtw-cloudfront-secret"
  force_destroy = true
}       

resource "aws_s3_bucket" "app-respond-aiwhatsapp-lambda" {
  bucket = "app-respond-aiwhatsapp-lambda"
  force_destroy = true
}       