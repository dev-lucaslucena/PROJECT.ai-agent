variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default = "app-respond-aiwhatsapp-lambda"
}

variable "repo_name" {
  description = "The name of the github repo is the same used for S3 bucket"
  type        = string
  default = "app-respond-aiwhatsapp-lambda"
}

variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
  default = "app-respond-aiwhatsapp-lambda"  
}