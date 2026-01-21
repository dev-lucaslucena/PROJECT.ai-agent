variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  default = ""
}

variable "repo_name" {
  description = "The name of the github repo is the same used for S3 bucket"
  type        = string
  default = null
}

variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
  default = ""  
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
  default = ["subnet-07ebeb1de5c227dc4", "subnet-0fc96d022380d9517", "subnet-0d812137ea7424ab4"]  
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default = "vpc-065e381aa9925d7fb"
}