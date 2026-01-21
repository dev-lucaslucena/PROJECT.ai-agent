resource "aws_cognito_user_pool" "aiglobalcognito" {
  name = "aiglobalcognito-user-pool"

  auto_verified_attributes = ["email"]

  # Password policy
  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
  }

  # Advanced security mode off
  mfa_configuration = "OFF"
}

resource "aws_cognito_user_pool_client" "aiglobalcognito" {
  name         = "aiglobalcognito-user-pool-client"
  user_pool_id = aws_cognito_user_pool.aiglobalcognito.id

  # OAuth2 configuration for most common providers
  supported_identity_providers = ["COGNITO", var.google_client_provider]

  allowed_oauth_flows_user_pool_client = true

  allowed_oauth_flows  = ["code"]
  allowed_oauth_scopes = ["email", "openid", "profile"]

  callback_urls = ["https://localhost.com/callback"]
  logout_urls   = ["https://localhost.com/logout"]

  explicit_auth_flows = ["ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  prevent_user_existence_errors = "ENABLED"

  depends_on = [aws_cognito_identity_provider.google]
}

# Identity providers configuration
resource "aws_cognito_identity_provider" "google" {
  user_pool_id  = aws_cognito_user_pool.aiglobalcognito.id
  provider_name = var.google_client_provider
  provider_type = var.google_client_provider
  attribute_mapping = {
    email    = "email"
    username = "sub"
  }
  provider_details = {
    client_id        = ""
    client_secret    = ""
    authorize_scopes = "email profile openid"
  }
  depends_on = [aws_cognito_user_pool.aiglobalcognito]
}

# Create Cognito Identity Pool to allow federated logins
resource "aws_cognito_identity_pool" "aiglobalcognito" {
  identity_pool_name               = "aiglobalcognito-identity-pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id     = aws_cognito_user_pool_client.aiglobalcognito.id
    provider_name = aws_cognito_user_pool.aiglobalcognito.endpoint
  }

  depends_on = [aws_cognito_user_pool_client.aiglobalcognito, aws_cognito_user_pool.aiglobalcognito]
}
