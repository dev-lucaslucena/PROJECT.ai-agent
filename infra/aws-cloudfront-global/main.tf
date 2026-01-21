resource "aws_cloudfront_origin_access_identity" "apigtw_global_oai" {
  comment = "OAI for accessing API Gateway"
}

resource "aws_cloudfront_distribution" "cloudfront_global" {
  origin {
    domain_name = replace(data.aws_apigatewayv2_api.apigtw_global.api_endpoint, "https://", "")
    origin_id   = "apiGatewayGlobalOrigin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }

  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for Global API Gateway"
  default_root_object = ""
  price_class = "PriceClass_100"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "apiGatewayGlobalOrigin"

    cache_policy_id = data.aws_cloudfront_cache_policy.default.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.default.id
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.default.id

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = "${data.aws_lambda_function.lambda.qualified_arn}"
      include_body = true
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}