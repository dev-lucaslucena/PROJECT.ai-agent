resource "aws_cloudwatch_log_group" "api_logs_prod" {
  name              = "/aws/apigateway/${var.gtw_name}/prod"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "api_logs_dev" {
  name              = "/aws/apigateway/${var.gtw_name}/dev"
  retention_in_days = 1
}
