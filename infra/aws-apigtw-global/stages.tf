resource "aws_apigatewayv2_deployment" "dev" {
  api_id = aws_apigatewayv2_api.apigtw_global.id  

  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    redeployment = timestamp()
  }
  
  depends_on = [
    aws_apigatewayv2_api.apigtw_global
  ]
}

resource "aws_apigatewayv2_deployment" "prod" {
  api_id = aws_apigatewayv2_api.apigtw_global.id

  lifecycle {
    create_before_destroy = true
  }
  
  depends_on = [
    aws_apigatewayv2_api.apigtw_global
  ]
}

# Create a stage for the API Gateway
resource "aws_apigatewayv2_stage" "prod_stage" {
  deployment_id = aws_apigatewayv2_deployment.prod.id
  api_id      = aws_apigatewayv2_api.apigtw_global.id
  name        = "prod"
  depends_on = [ aws_apigatewayv2_deployment.prod, aws_cloudwatch_log_group.api_logs_prod ]

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs_prod.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }

  route_settings {
    route_key = "$default"
    data_trace_enabled = false
    detailed_metrics_enabled = false
    logging_level = "INFO"
    throttling_burst_limit = 1000
    throttling_rate_limit = 500
  }
}

resource "aws_apigatewayv2_stage" "dev_stage" {
  deployment_id = aws_apigatewayv2_deployment.dev.id
  api_id      = aws_apigatewayv2_api.apigtw_global.id
  name        = "dev"
  depends_on = [ aws_apigatewayv2_deployment.dev, aws_cloudwatch_log_group.api_logs_dev ]

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_logs_dev.arn
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }

  route_settings {
    route_key = "$default"
    data_trace_enabled = false
    detailed_metrics_enabled = false
    logging_level = "INFO"
    throttling_burst_limit = 20
    throttling_rate_limit = 5
  }
}