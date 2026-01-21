data "aws_s3_object" "lambda_zip" {
  bucket = "${var.bucket_name}"
  key    = "lambda.zip"
}

data "aws_sqs_queue" "lambda_queue" {
  name = "${var.queue_name}"
}