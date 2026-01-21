variable "edge_function_arn" {
  description = "ARN of the Lambda@Edge function"
  type        = string
  default = "arn:aws:lambda:us-east-1:123456789012:function:cloudfront-edgelambda-global"
}