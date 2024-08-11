terraform {
  required_providers {
    snowflake = {
      source = "Snowflake-Labs/snowflake"
      version = "0.94.1"
    }
  }
}

# Using environmental variables
provider "snowflake" {
  account                = var.snowflake_account
  user                   = var.snowflake_user
  password               = var.snowflake_password
  authenticator          = "Snowflake" 

  # Not required for my authentication method. 
  # region    = "us-east-2"
  # role      = "your_role"
  # warehouse = "your_warehouse"
  # database  = "your_database"

  # Not using OAuth or private key authentication
  # oauth_access_token     = "..."
  # private_key_path       = "..."
  # private_key            = "..."
  # private_key_passphrase = "..."
  # oauth_refresh_token    = "..."
  # oauth_client_id        = "..."
  # oauth_client_secret    = "..."
  # oauth_endpoint         = "..."
  # oauth_redirect_url     = "..."
}
