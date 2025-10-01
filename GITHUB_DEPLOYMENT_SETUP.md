# GitHub Actions Deployment Setup

This document provides step-by-step instructions for setting up GitHub Actions to deploy your Auth0 Terraform infrastructure.

## 🔐 Required Repository Secrets

### 1. Auth0 Management API Credentials

You need to set up the following secrets in your GitHub repository:

**Repository Settings → Secrets and Variables → Actions → Repository Secrets**

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `AUTH0_DOMAIN` | Your Auth0 tenant domain | `dev-example.us.auth0.com` |
| `AUTH0_CLIENT_ID` | Management API Application Client ID | `abc123xyz789` |
| `AUTH0_CLIENT_SECRET` | Management API Application Client Secret | `secretkey123` |

**Note:** You can use the same Auth0 tenant for all environments, or set up separate tenants per environment using environment-specific secrets (see Environment Secrets section below).

### 2. How to Get Auth0 Credentials

1. **Login to Auth0 Dashboard**
   - Go to [Auth0 Dashboard](https://manage.auth0.com/)
   - Navigate to your tenant

2. **Create/Configure Management API Application**
   - Go to **Applications** → **Machine to Machine Applications**
   - Find or create an application for "Auth0 Management API"
   - Note down the **Client ID** and **Client Secret**

3. **Grant Required Scopes**
   The application needs these Management API scopes:
   ```
   read:clients, create:clients, update:clients, delete:clients
   read:client_grants, create:client_grants, update:client_grants, delete:client_grants
   read:users, create:users, update:users, delete:users
   read:user_roles, create:user_roles, delete:user_roles
   read:roles, create:roles, update:roles, delete:roles
   read:resource_servers, create:resource_servers, update:resource_servers, delete:resource_servers
   read:connections, create:connections, update:connections, delete:connections
   read:tenant_settings, update:tenant_settings
   read:custom_domains, create:custom_domains, update:custom_domains, delete:custom_domains
   read:actions, create:actions, update:actions, delete:actions
   ```

## 🌍 GitHub Environments Setup

### 1. Create Environments

**Repository Settings → Environments → New Environment**

Create three environments:
- `dev` - Development environment
- `qa` - Quality Assurance/Testing environment  
- `prod` - Production environment

### 2. Environment Protection Rules

#### For `prod` environment:
- ✅ **Required reviewers**: Add team members who should approve production deployments
- ✅ **Wait timer**: Set 10-15 minutes to allow for thorough review
- ✅ **Deployment branches**: Restrict to `main` branch only

#### For `qa` environment:
- ✅ **Required reviewers**: Add QA team members or lead developers
- ✅ **Wait timer**: Set 5 minutes to allow for quick review
- ✅ **Deployment branches**: Allow `qa`, `release/*` branches, and `main`

#### For `dev` environment:
- ✅ **Deployment branches**: Allow `develop`, `dev`, and feature branches
- ⚠️ **Required reviewers**: Optional (can be enabled for additional safety)

### 3. Environment Secrets

You can also set environment-specific secrets if needed:

**Environments → [Environment Name] → Environment Secrets**

This is useful if you have different Auth0 tenants for dev/prod.

## 🚀 Deployment Workflows

### Automatic Deployments

1. **Development**: Push to `develop` or `dev` branch → Deploys to `dev` environment
2. **Quality Assurance**: Push to `qa` branch or `release/*` branches → Deploys to `qa` environment (with approval)
3. **Production**: Push to `main` branch → Deploys to `prod` environment (with approval)

### Manual Deployments

1. Go to **Actions** tab in GitHub
2. Select **Deploy Auth0 Infrastructure** workflow
3. Click **Run workflow**
4. Choose environment and options
5. Click **Run workflow**

## 🔧 Terraform State Management

### Option 1: Local State (Current Setup)
- State files are maintained locally in the repository
- **⚠️ Warning**: This can cause conflicts with multiple developers

### Option 2: Remote State Backend (Recommended)

Add to your `main.tf`:

```hcl
terraform {
  backend "s3" {
    # AWS S3 Backend
    bucket = "your-terraform-state-bucket"
    key    = "auth0/terraform.tfstate"
    region = "us-east-1"
  }
  
  # OR Azure Backend
  # backend "azurerm" {
  #   resource_group_name  = "terraform-state-rg"
  #   storage_account_name = "terraformstatestorage"
  #   container_name       = "tfstate"
  #   key                  = "auth0.terraform.tfstate"
  # }
}
```

Then add additional secrets for backend authentication:
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` (for S3)
- `ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`, `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID` (for Azure)

## 📋 Workflow Features

### ✅ What the workflow does:

1. **Environment Detection**: Automatically determines target environment based on branch
2. **Permission Validation**: Verifies Auth0 API permissions before deployment
3. **Terraform Plan**: Shows changes before applying them
4. **PR Comments**: Automatically comments Terraform plan on Pull Requests
5. **Approval Gates**: Requires manual approval for production deployments
6. **Rollback**: Easy rollback via Terraform state management
7. **Notifications**: Clear success/failure notifications

### 🔒 Security Features:

1. **Secret Management**: Credentials stored securely in GitHub Secrets
2. **Environment Isolation**: Separate environments with different protection rules  
3. **Branch Protection**: Production only deploys from `main` branch
4. **Audit Trail**: All deployments logged in GitHub Actions history

## 🐛 Troubleshooting

### Common Issues:

1. **Auth0 Permission Errors**
   - Verify Management API scopes are granted
   - Check client credentials are correct

2. **Terraform Plan Failures**
   - Check `.tfvars` files exist and are valid
   - Verify Auth0 resources don't conflict with existing ones

3. **Environment Access Issues**
   - Ensure you're added as a reviewer for protected environments
   - Check environment deployment branch restrictions

### Debugging:

1. Check workflow logs in **Actions** tab
2. Review Terraform plan output in PR comments
3. Verify secrets are set correctly in repository settings

## 📚 Next Steps

1. Set up the required secrets (see above)
2. Create the GitHub environments
3. Test with a small change to the `develop` branch
4. Configure team members as reviewers for production
5. Consider setting up remote Terraform state backend
6. Add additional monitoring and alerting as needed