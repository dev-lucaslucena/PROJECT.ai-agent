data "aws_s3_object" "lambda_zip" {
  bucket = "${var.bucket_name}"
  key    = "lambda.zip"
}

data "aws_caller_identity" "current" {}

