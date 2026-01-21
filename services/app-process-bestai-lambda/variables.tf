variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default = "app-process-bestai-lambda"
}

variable "repo_name" {
  description = "The name of the github repo is the same used for S3 bucket"
  type        = string
  default = "app-process-bestai-lambda"
}

variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
  default = "app-process-bestai-lambda"  
}

variable "queue_name" {
  description = "Name of the SQS queue"
  type        = string
  default = "inbound-ai-process-sqs.fifo"
  
}