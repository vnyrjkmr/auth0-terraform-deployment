# Development environment
auth0_domain        = "dev-ttiw0oehq6nnv2jk.us.auth0.com"
auth0_client_id     = "oKs0PcU5MhzDnKQqalf1xQKYLE4YsCOK"
auth0_client_secret = "M5aaGAZTJG4-tD7rMQMBECk9TWUHDrAMG0wCRFyFvYqOoIskj7juIdtj5BBUDpdB"

project_name = "my-app-dev-1"

# Tenant Configuration
tenant_friendly_name = "ITCyberSecSol"
tenant_support_email = "support@ITCyberSecSol.com"
#custom_domain_name = "auth.ITCyberSecSol.com"

# Role definitions
roles = {
  admin = {
    name        = "Administrator"
    description = "Full system administrator access"
    permissions = [
      {
        resource_server_identifier = "https://api.itcybersecsol.com"
        name                      = "read:users"
      },
      {
        resource_server_identifier = "https://api.itcybersecsol.com"
        name                      = "write:users"
      },
      {
        resource_server_identifier = "https://admin-api.itcybersecsol.com"
        name                      = "read:admin"
      },
      {
        resource_server_identifier = "https://admin-api.itcybersecsol.com"
        name                      = "write:admin"
      }
    ]
  },
  user = {
    name        = "Standard User"
    description = "Regular user access"
    permissions = [
      {
        resource_server_identifier = "https://api.itcybersecsol.com"
        name                      = "read:users"
      }
    ]
  }
}

# Application definitions
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
  main_api = {
    name         = "ITCyberSecSol Main API"
    type         = "api"
    description  = "Main backend API service"
    api_identifier = "https://api.itcybersecsol.com"
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
    api_identifier = "https://admin-api.itcybersecsol.com"
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
api_identifier = "https://api-dev.example.com"

environment = "dev"

