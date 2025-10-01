# Quality Assurance (QA/Staging) environment - MINIMAL CONFIG
# Auth0 credentials are now managed via GitHub Secrets for security
# The workflow will inject these values during deployment

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
