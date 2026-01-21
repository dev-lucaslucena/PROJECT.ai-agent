data "aws_s3_object" "lambda_zip" {
  bucket = "${var.bucket_name}"
  key    = "lambda.zip"
}

data "aws_sns_topic" "respond_ai_global_sns" {
  name = "example-sns-topic"
}