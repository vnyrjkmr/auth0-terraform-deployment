# Production environment - MINIMAL CONFIG
auth0_domain        = "dev-ttiw0oehq6nnv2jk.us.auth0.com"  # Update with your production Auth0 tenant
auth0_client_id     = "oKs0PcU5MhzDnKQqalf1xQKYLE4YsCOK"  # Production Management API credentials
auth0_client_secret = "M5aaGAZTJG4-tD7rMQMBECk9TWUHDrAMG0wCRFyFvYqOoIskj7juIdtj5BBUDpdB"

project_name = "my-app-production-minimal"

# Resource Creation Control - SKIP EVERYTHING TO AVOID CONFLICTS
skip_existing_applications      = true   # Skip applications to avoid tenant limits
skip_existing_resource_servers = true   # Skip resource servers to avoid conflicts
skip_existing_database        = true   # Skip database to avoid conflicts
skip_existing_action          = true   # Skip actions

# Tenant Configuration - Only update tenant settings
tenant_friendly_name = "ITCyberSecSol Production"
tenant_support_email = "support@ITCyberSecSol.com"

# Empty applications to skip all app creation
applications = {}

environment = "prod"
primary_color = "#cc0000"
