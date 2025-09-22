# Configure the Auth0 Provider
terraform {
  required_providers {
    auth0 = {
      source  = "auth0/auth0"
      version = "~> 1.0"
    }
  }
  required_version = ">= 1.0"
}

# Configure Auth0 Provider
provider "auth0" {
  domain        = var.auth0_domain
  client_id     = var.auth0_client_id
  client_secret = var.auth0_client_secret
}

# Auth0 Tenant Configuration
resource "auth0_tenant" "tenant" {
  friendly_name      = var.tenant_friendly_name
  support_email      = var.tenant_support_email
  support_url        = var.tenant_support_url
  default_audience   = var.tenant_default_audience
  default_directory  = "Username-Password-Authentication"
}

# Custom Domain Configuration
#resource "auth0_custom_domain" "domain" {
#  count  = var.custom_domain_name != "" ? 1 : 0
#  domain = var.custom_domain_name
#  type   = var.custom_domain_type
#}
# Attack Protection
resource "auth0_attack_protection" "breached_password_detection" {
 # breached_password_detection {
  #  enabled                = true
   # shields                = ["block", "admin_notification"]
   # admin_notification_frequency = ["daily"]
  #}
  brute_force_protection {
    enabled      = true
    shields      = ["block"]
  }
  suspicious_ip_throttling {
    enabled      = true
    shields      = ["admin_notification", "block"]
  }
}

# Branding
resource "auth0_branding" "main" {
  logo_url = var.logo_url
  colors {
    primary         = var.primary_color 
  }
}

# Multiple Auth0 Applications
resource "auth0_client" "applications" {
  for_each = var.skip_existing_applications ? {} : var.applications

  name                = each.value.name
  description         = each.value.description
  app_type            = each.value.type == "spa" ? "spa" : "non_interactive"
  callbacks           = each.value.type == "spa" ? each.value.callbacks : null
  allowed_logout_urls = each.value.type == "spa" ? each.value.logout_urls : null
  allowed_origins     = each.value.type == "spa" ? each.value.allowed_origins : null
  web_origins         = each.value.type == "spa" ? each.value.web_origins : null
  oidc_conformant     = true
  
  jwt_configuration {
    lifetime_in_seconds = 36000
    secret_encoded      = true
    alg                 = "RS256"
  }
}

# Resource Servers for API Applications
resource "auth0_resource_server" "apis" {
  for_each = var.skip_existing_resource_servers ? {} : {
    for k, v in var.applications : k => v
    if v.type == "api"
  }

  name        = each.value.name
  identifier  = each.value.api_identifier
  signing_alg = "RS256"

  allow_offline_access = true
  token_lifetime      = 86400
  skip_consent_for_verifiable_first_party_clients = true

  lifecycle {
    ignore_changes = [
      identifier,
      name,
      signing_alg,
      allow_offline_access,
      token_lifetime,
      skip_consent_for_verifiable_first_party_clients
    ]
  }
}

# API Scopes
resource "auth0_resource_server_scopes" "api_scopes_new" {
  for_each = var.skip_existing_resource_servers ? {} : {
    for k, v in var.applications : k => v
    if v.type == "api" && length(v.api_scopes) > 0
  }

  resource_server_identifier = auth0_resource_server.apis[each.key].identifier

  dynamic "scopes" {
    for_each = each.value.api_scopes
    content {
      name        = scopes.value.name
      description = scopes.value.description
    }
  }
}

# Roles
resource "auth0_role" "roles" {
  for_each = var.roles

  name        = each.value.name
  description = each.value.description
}

# Role Permissions
resource "auth0_role_permission" "role_permissions" {
  for_each = {
    for entry in flatten([
      for role_key, role in var.roles : [
        for permission in role.permissions : {
          role_key     = role_key
          resource_server_identifier = permission.resource_server_identifier
          permission_name = permission.name
        }
      ]
    ]) : "${entry.role_key}-${entry.permission_name}" => entry
  }

  role_id = auth0_role.roles[each.value.role_key].id
  resource_server_identifier = each.value.resource_server_identifier
  permission = each.value.permission_name
}

# Legacy Auth0 Application (API/Backend) - maintained for backward compatibility
resource "auth0_client" "api_app" {
  count       = (var.api_app_name != "" && !var.skip_existing_applications) ? 1 : 0
  name        = var.api_app_name
  description = "API Application for ${var.project_name}"
  app_type    = "non_interactive"
  
  jwt_configuration {
    lifetime_in_seconds = 36000
    secret_encoded      = true
    alg                 = "RS256"
  }
}

# Legacy Auth0 Resource Server (API) - maintained for backward compatibility
resource "auth0_resource_server" "api" {
  count = (var.api_name != "" && !var.skip_existing_resource_servers) ? 1 : 0
  
  name       = var.api_name
  identifier = var.api_identifier

  allow_offline_access = true
  token_lifetime      = 86400
  skip_consent_for_verifiable_first_party_clients = true

  lifecycle {
    ignore_changes = [
      identifier,
      name,
      allow_offline_access,
      token_lifetime,
      skip_consent_for_verifiable_first_party_clients
    ]
  }
}

# Auth0 Client Grant (API permissions)
resource "auth0_client_grant" "api_grant" {
  count     = (var.api_name != "" && !var.skip_existing_applications && !var.skip_existing_resource_servers) ? 1 : 0
  client_id = length(auth0_client.api_app) > 0 ? auth0_client.api_app[0].id : ""
  audience  = length(auth0_resource_server.api) > 0 ? auth0_resource_server.api[0].identifier : ""
  
  scopes = [
    "read:users",
    "write:users"
  ]
}

# Auth0 Connection (Database)
resource "auth0_connection" "database" {
  count    = var.skip_existing_database ? 0 : 1
  name     = replace(lower("${var.project_name}-db"), " ", "-")
  strategy = "auth0"
  
  options {
    password_policy                = "good"
    password_history {
      enable = true
      size   = 5
    }
    password_no_personal_info {
      enable = true
    }
    password_dictionary {
      enable     = true
      dictionary = ["password", "admin", "123456"]
    }
    password_complexity_options {
      min_length = 8
    }
    enabled_database_customization = true
    brute_force_protection         = true
    import_mode                    = false
    disable_signup                 = false
    requires_username              = false
  }
}

# Enable connection for applications
resource "auth0_connection_clients" "app_connections" {
  count         = var.skip_existing_database ? 0 : 1
  connection_id = auth0_connection.database[0].id
  enabled_clients = [
    for k, v in auth0_client.applications : v.id if v.app_type == "spa"
  ]
}

# Role permissions are now handled by the auth0_role_permission resource with for_each

# Data source to check if login action exists
data "auth0_action" "existing_action" {
  name = "add-user-metadata"
}

locals {
  existing_login_action = data.auth0_action.existing_action.id != ""
}

# Auth0 Action (Login Flow)
resource "auth0_action" "login_action" {
  count = (!local.existing_login_action && !var.skip_existing_action) ? 1 : 0
  name  = "add-user-metadata"
  
  supported_triggers {
    id      = "post-login"
    version = "v3"
  }

  lifecycle {
    prevent_destroy = true
    ignore_changes = all
  }
  
  code = <<-EOT
    exports.onExecutePostLogin = async (event, api) => {
      const namespace = 'https://example.com';
      
      if (event.authorization) {
        api.idToken.setCustomClaim(namespace + '/roles', event.authorization.roles);
        api.accessToken.setCustomClaim(namespace + '/roles', event.authorization.roles);
      }
      
      api.user.setAppMetadata('last_login', new Date().toISOString());
    };
  EOT
  
  dependencies {
    name    = "lodash"
    version = "4.17.21"
  }
  
  runtime = "node18"
  deploy  = true
}
