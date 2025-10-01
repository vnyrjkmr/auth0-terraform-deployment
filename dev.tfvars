# Development environment
auth0_domain        = "dev-3ey3z12ipauxwzup.us.auth0.com"
auth0_client_id     = "ZNA0WDKKxRUuiaZzQtS06P4ksrKCP3yu"
auth0_client_secret = "IBWzaVffwmwHerh6HT77q7YJnmsOwBGonU22vd-ga6QyT4-Wnc_hRj1emTWvBOeZ"



project_name = "my-app-dev-new"

# Resource Creation Control
skip_existing_applications      = false  # Set to false to create new applications
skip_existing_resource_servers = false  # Set to false to create new resource servers
skip_existing_database        = false  # Set to false to create new database connections
skip_existing_action          = false  # Set to false to create new actions

# Tenant Configuration
tenant_friendly_name = "ITCyberSecSol"
tenant_support_email = "support@ITCyberSecSol.com"
#custom_domain_name = "auth.ITCyberSecSol.com"

# Application definitions
applications = {
  main_app_new = {
    name        = "ITCyberSecSol Main App New app 1"
    type        = "spa"
    description = "Main customer portal application New app 1"
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
  admin_dashboard = {
    name        = "ITCyberSecSol Admin Dashboard"
    type        = "spa"
    description = "Administrative dashboard application"
    callbacks   = [
      "http://localhost:3001/callback",
      "https://admin.itcybersecsol.com/callback"
    ]
    logout_urls = [
      "http://localhost:3001",
      "https://admin.itcybersecsol.com"
    ]
    allowed_origins = [
      "http://localhost:3001",
      "https://admin.itcybersecsol.com"
    ]
    web_origins = [
      "http://localhost:3001",
      "https://admin.itcybersecsol.com"
    ]
  },
  admin_test_app = {
    name        = "ITCyberSecSol Admin test app"
    type        = "spa"
    description = "Administrative dashboard application"
    callbacks   = [
      "http://localhost:5001/callback",
      "https://admin.itcybersecsol1.com/callback"
    ]
    logout_urls = [
      "http://localhost:5001",
      "https://admin.itcybersecsol1.com"
    ]
    allowed_origins = [
      "http://localhost:5001",
      "https://admin.itcybersecsol1.com"
    ]
    web_origins = [
      "http://localhost:5001",
      "https://admin.itcybersecsol1.com"
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
  },
  admin_api = {
    name         = "ITCyberSecSol Admin API"
    type         = "api"
    description  = "Administrative API service"
    api_identifier = "https://admin-api.itcybersecsol2.com"
    api_scopes   = [
      {
        name        = "read:admin"
        description = "Read administrative data"
      },
      {
        name        = "write:admin"
        description = "Write administrative data"
      }
    ]
  }
}

api_app_name = "ITCyberSecSol_APITestapp"
api_name     = "ITCyberSecSol_APITestapp"
api_identifier = "https://api-dev.example2.com"

environment = "dev"

primary_color = "#af0ed7"
