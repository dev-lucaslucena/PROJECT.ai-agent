resource "aws_ssm_parameter" "facebook_webhook_verify_token" {
  name  = "FACEBOOK_WEBHOOK_VERIFY_TOKEN"
  type  = "String"
  value = "temporary_value" # Temporary value to satisfy the constraint

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "facebook_app_secret_rico" {
  name  = "FACEBOOK_APP_SECRET_RICO"
  type  = "String"
  value = "temporary_value" # Temporary value to satisfy the constraint

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "openai_api_secret_key" {
  name  = "OPENAI_API_SECRET_KEY"
  type  = "String"
  value = "temporary_value" # Temporary value to satisfy the constraint

  lifecycle {
    ignore_changes = [value]
  }
}


resource "aws_ssm_parameter" "valid_api_keys" {
  name  = "VALID_API_KEYS"
  type  = "String"
  value = "temporary_value" # Temporary value to satisfy the constraint

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "apigtw_cloudfront_secret" {
  name  = "APIGTW_CLOUDFRONT_SECRET"
  type  = "String"
  value = "temporary_value" # Temporary value to satisfy the constraint

  lifecycle {
    ignore_changes = [value]
  }
}

