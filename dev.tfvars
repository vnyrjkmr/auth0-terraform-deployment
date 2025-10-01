# Development environment - MINIMAL to avoid all conflicts and limits
# Auth0 credentials are now managed via GitHub Secrets for security
# The workflow will inject these values during deployment

project_name = "my-app-dev-minimal"

# Resource Creation Control - SKIP EVERYTHING TO AVOID CONFLICTS
skip_existing_applications      = true   # Skip applications to avoid tenant limits
skip_existing_resource_servers = true   # Skip resource servers to avoid conflicts
skip_existing_database        = true   # Skip database to avoid conflicts
skip_existing_action          = true   # Skip actions

# Tenant Configuration - Only update tenant settings
tenant_friendly_name = "ITCyberSecSol Dev"
tenant_support_email = "support@ITCyberSecSol.com"

# Empty applications to skip all app creation
applications = {}

environment = "dev"
primary_color = "#af0ed7"