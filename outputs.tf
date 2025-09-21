# Application Outputs
output "applications" {
  description = "Map of created applications and their details"
  value = {
    for k, v in auth0_client.applications : k => {
      client_id = v.client_id
      type      = v.app_type
    }
  }
  sensitive = true
}

# Resource Server Outputs
output "resource_servers" {
  description = "Map of created API resource servers"
  value = {
    for k, v in auth0_resource_server.apis : k => {
      identifier = v.identifier
    }
  }
}

# Connection Outputs
output "database_connection_id" {
  description = "ID of the database connection"
  value       = auth0_connection.database.id
}

output "database_connection_name" {
  description = "Name of the database connection"
  value       = auth0_connection.database.name
}

# Role Outputs
output "roles" {
  description = "Map of created roles"
  value = {
    for k, v in auth0_role.roles : k => {
      id          = v.id
      name        = v.name
      description = v.description
    }
  }
}

# Auth0 Domain Output
output "auth0_domain" {
  description = "Auth0 tenant domain"
  value       = var.auth0_domain
}

# Complete Auth0 Configuration for Frontend Apps
output "auth0_config" {
  description = "Complete Auth0 configuration for frontend applications"
  value = {
    domain = var.auth0_domain
    applications = {
      for k, v in auth0_client.applications : k => {
        client_id = v.client_id
        type      = v.app_type
      } if v.app_type == "spa"
    }
  }
}
