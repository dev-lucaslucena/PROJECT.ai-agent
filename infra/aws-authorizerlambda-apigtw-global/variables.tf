variable "gtw_name" {
  description = "Name of the gateway"
  type        = string
  default = "apigtw-global"
}

variable "repo_name" {
  description = "Name of the repository"
  type        = string
  default = "aws-authorizerlambda-apigtw-global"
}

variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
  default = "aws-authorizerlambda-apigtw-global"  
}

variable "lambda_name" {
  description = "Name of the lambda"
  type        = string
  default = "authorizerlambda-apigtw-global"
}