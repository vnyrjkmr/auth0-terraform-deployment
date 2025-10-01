# Quality Assurance (QA/Staging) environment - MINIMAL CONFIG
auth0_domain        = "dev-3ey3z12ipauxwzup.us.auth0.com"  # Using same tenant as dev for testing
auth0_client_id     = "ZNA0WDKKxRUuiaZzQtS06P4ksrKCP3yu"  # Same Management API credentials
auth0_client_secret = "IBWzaVffwmwHerh6HT77q7YJnmsOwBGonU22vd-ga6QyT4-Wnc_hRj1emTWvBOeZ"

project_name = "my-app-staging-minimal"

# Resource Creation Control - SKIP EVERYTHING TO AVOID CONFLICTS
skip_existing_applications      = true   # Skip applications to avoid tenant limits
skip_existing_resource_servers = true   # Skip resource servers to avoid conflicts
skip_existing_database        = true   # Skip database to avoid conflicts
skip_existing_action          = true   # Skip actions

# Tenant Configuration - Only update tenant settings
tenant_friendly_name = "ITCyberSecSol Staging"
tenant_support_email = "staging-support@ITCyberSecSol.com"

# Empty applications to skip all app creation
applications = {}

environment = "staging"
primary_color = "#0066cc"
