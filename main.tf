resource "aws_cognito_user_pool" "cognito_user_pool" {
  name = "${var.tag}-user-pool"

  schema {
    name = "Email"
    attribute_data_type = "String"
    mutable = true
    developer_only_attribute = false
  }

  email_configuration {
    email_sending_account = "COGNITO_DEFAULT"
  }

  auto_verified_attributes = [ "email" ]

  password_policy {
    minimum_length = 8
    require_lowercase = true
    require_numbers = true
    require_uppercase = true
    require_symbols = true
    temporary_password_validity_days = 4
  }

  username_attributes = [ "email" ]

  username_configuration {
    case_sensitive = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name = "verified_email"
      priority = 1
    }
  }
}

resource "aws_cognito_user_pool_client" "cognito_user_pool_client" {
  name = "${var.tag}-user-pool-client"
  supported_identity_providers = [ "COGNITO" ]
  user_pool_id = aws_cognito_user_pool.cognito_user_pool.id
  explicit_auth_flows = [ "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD_AUTH" ]
  generate_secret = false
  prevent_user_existence_errors = "LEGACY"
  refresh_token_validity = 1
  access_token_validity = 1
  id_token_validity = 1
  token_validity_units {
    access_token = "hours"
    id_token = "hours"
    refresh_token = "hours"
  }
}