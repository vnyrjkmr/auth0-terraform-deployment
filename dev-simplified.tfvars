# Development environment - SIMPLIFIED for tenant limits
auth0_domain        = "dev-3ey3z12ipauxwzup.us.auth0.com"
auth0_client_id     = "ZNA0WDKKxRUuiaZzQtS06P4ksrKCP3yu"
auth0_client_secret = "IBWzaVffwmwHerh6HT77q7YJnmsOwBGonU22vd-ga6QyT4-Wnc_hRj1emTWvBOeZ"

project_name = "my-app-dev-simplified"

# Resource Creation Control
skip_existing_applications      = false  # Set to false to create new applications
skip_existing_resource_servers = false  # Set to false to create new resource servers
skip_existing_database        = false  # Set to false to create new database connections
skip_existing_action          = true   # Set to true to skip actions that might not exist yet

# Tenant Configuration
tenant_friendly_name = "ITCyberSecSol Dev"
tenant_support_email = "support@ITCyberSecSol.com"

# SIMPLIFIED Application definitions - only 2 apps to avoid tenant limits
applications = {
  main_app = {
    name        = "ITCyberSecSol Main App"
    type        = "spa"
    description = "Main customer portal application"
    callbacks   = [
      "http://localhost:3000/callback",
      "https://main.itcybersecsol.com/callback"
    ]
    logout_urls = [
      "http://localhost:3000",
      "https://main.itcybersecsol.com"
    ]
    allowed_origins = [
      "http://localhost:3000",
      "https://main.itcybersecsol.com"
    ]
    web_origins = [
      "http://localhost:3000",
      "https://main.itcybersecsol.com"
    ]
  },
  main_api = {
    name         = "ITCyberSecSol Main API"
    type         = "api"
    description  = "Main backend API service"
    api_identifier = "https://api.itcybersecsol2.com"
    api_scopes   = [
      {
        name        = "read:users"
        description = "Read user information"
      },
      {
        name        = "write:users"
        description = "Write user information"
      }
    ]
  }
}

# Skip the additional api_app to reduce application count
# api_app_name = "ITCyberSecSol_APITestapp"
# api_name     = "ITCyberSecSol_APITestapp"
# api_identifier = "https://api-dev.example2.com"

environment = "dev"
primary_color = "#af0ed7"