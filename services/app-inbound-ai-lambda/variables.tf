variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default = "app-inbound-ai-lambda"
}

variable "repo_name" {
  description = "The name of the github repo is the same used for S3 bucket"
  type        = string
  default = null
}

variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
  default = "app-inbound-ai-lambda"  
}