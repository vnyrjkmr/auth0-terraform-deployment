# Quality Assurance (QA) environment
auth0_domain        = "qa-ttiw0oehq6nnv2jk.us.auth0.com"  # Update with your QA Auth0 domain
auth0_client_id     = "qa-client-id-placeholder"          # Update with your QA Management API Client ID
auth0_client_secret = "qa-client-secret-placeholder"      # Update with your QA Management API Client Secret

project_name = "my-app-qa"

# Resource Creation Control
skip_existing_applications      = false  # Set to false to create new applications
skip_existing_resource_servers = false  # Set to false to create new resource servers
skip_existing_database        = false  # Set to false to create new database connections
skip_existing_action          = false  # Set to false to create new actions

# Tenant Configuration
tenant_friendly_name = "ITCyberSecSol QA"
tenant_support_email = "qa-support@ITCyberSecSol.com"
#custom_domain_name = "qa-auth.ITCyberSecSol.com"

# Application definitions
applications = {
  main_app_qa = {
    name        = "ITCyberSecSol Main App QA"
    type        = "spa"
    description = "Main customer portal application for QA testing"
    callbacks   = [
      "https://qa.itcybersecsol.com/callback",
      "https://qa-app.itcybersecsol.com/callback"
    ]
    logout_urls = [
      "https://qa.itcybersecsol.com",
      "https://qa-app.itcybersecsol.com"
    ]
    allowed_origins = [
      "https://qa.itcybersecsol.com",
      "https://qa-app.itcybersecsol.com"
    ]
    web_origins = [
      "https://qa.itcybersecsol.com",
      "https://qa-app.itcybersecsol.com"
    ]
  },
  admin_portal_qa = {
    name        = "ITCyberSecSol Admin Portal QA"
    type        = "spa"
    description = "Administrative portal for QA testing"
    callbacks   = [
      "https://qa-admin.itcybersecsol.com/callback"
    ]
    logout_urls = [
      "https://qa-admin.itcybersecsol.com"
    ]
    allowed_origins = [
      "https://qa-admin.itcybersecsol.com"
    ]
    web_origins = [
      "https://qa-admin.itcybersecsol.com"
    ]
  },
  api_qa = {
    name        = "ITCyberSecSol API QA"
    type        = "non_interactive"
    description = "Backend API application for QA environment"
  }
}

# Resource Server definitions
resource_servers = {
  main_api_qa = {
    name        = "ITCyberSecSol Main API QA"
    identifier  = "https://qa-api.itcybersecsol.com"
    scopes = [
      {
        value       = "read:profile"
        description = "Read user profile information"
      },
      {
        value       = "write:profile"
        description = "Update user profile information"
      },
      {
        value       = "read:admin"
        description = "Read administrative data"
      },
      {
        value       = "write:admin"
        description = "Write administrative data"
      },
      {
        value       = "manage:users"
        description = "Manage user accounts"
      }
    ]
  }
}

# Role definitions
roles = {
  qa_user = {
    name        = "QA User"
    description = "Standard user role for QA testing"
    permissions = [
      "read:profile",
      "write:profile"
    ]
  },
  qa_admin = {
    name        = "QA Administrator"
    description = "Administrative role for QA testing"
    permissions = [
      "read:profile",
      "write:profile",
      "read:admin",
      "write:admin",
      "manage:users"
    ]
  },
  qa_tester = {
    name        = "QA Tester"
    description = "QA testing role with elevated permissions for testing scenarios"
    permissions = [
      "read:profile",
      "write:profile",
      "read:admin"
    ]
  }
}

# Database connections
databases = {
  qa_users_db = {
    name           = "QA-Users-Database"
    strategy       = "auth0"
    enabled_clients = ["main_app_qa", "admin_portal_qa"]
    options = {
      password_policy                = "good"
      password_history               = 3
      password_no_personal_info      = true
      password_dictionary           = true
      brute_force_protection        = true
      disable_signup                = false
      requires_username             = false
      custom_scripts = {
        get_user = "function getByEmail(email, callback) { /* QA-specific logic */ }"
      }
    }
  }
}

# Actions
actions = {
  qa_login_flow = {
    name    = "QA Login Enhancement"
    trigger = "post-login"
    code    = <<EOF
exports.onExecutePostLogin = async (event, api) => {
  // QA-specific login enhancements
  if (event.user.email && event.user.email.includes('@qa.')) {
    api.user.setAppMetadata('environment', 'qa');
    api.user.setAppMetadata('qa_session', true);
  }
};
EOF
    dependencies = [
      {
        name    = "moment"
        version = "2.29.4"
      }
    ]
  }
}

# Branding
logo_url = "https://qa-assets.itcybersecsol.com/logo.png"
primary_color = "#FF6B35"  # Orange for QA to distinguish from prod
page_background_color = "fff4f0"  # Light orange background

# Environment-specific settings
environment = "staging"
debug_mode = true  # Enable debug mode for QA
logging_level = "debug"
session_timeout = 7200  # 2 hours for QA testing
max_login_attempts = 10  # More lenient for QA testing