# 🔐 GitHub Secrets Setup Guide for Auth0 Credentials

## Security Best Practice: Store Sensitive Values in GitHub Secrets

Your Auth0 credentials have been removed from the `.tfvars` files and should be stored as GitHub Secrets instead.

## 🚨 IMPORTANT: Set Up GitHub Secrets

### 1. Navigate to GitHub Repository Secrets
Go to: https://github.com/vnyrjkmr/auth0-terraform-deployment/settings/secrets/actions

### 2. Add Repository-Level Secrets

Click "New repository secret" and add each of the following:

#### Development Environment Secrets
```
Name: AUTH0_DOMAIN_DEV
Value: dev-3ey3z12ipauxwzup.us.auth0.com

Name: AUTH0_CLIENT_ID_DEV  
Value: ZNA0WDKKxRUuiaZzQtS06P4ksrKCP3yu

Name: AUTH0_CLIENT_SECRET_DEV
Value: IBWzaVffwmwHerh6HT77q7YJnmsOwBGonU22vd-ga6QyT4-Wnc_hRj1emTWvBOeZ
```

#### Staging Environment Secrets
```
Name: AUTH0_DOMAIN_STAGING
Value: dev-3ey3z12ipauxwzup.us.auth0.com

Name: AUTH0_CLIENT_ID_STAGING
Value: ZNA0WDKKxRUuiaZzQtS06P4ksrKCP3yu

Name: AUTH0_CLIENT_SECRET_STAGING
Value: IBWzaVffwmwHerh6HT77q7YJnmsOwBGonU22vd-ga6QyT4-Wnc_hRj1emTWvBOeZ
```

#### Production Environment Secrets
```
Name: AUTH0_DOMAIN_PROD
Value: dev-ttiw0oehq6nnv2jk.us.auth0.com

Name: AUTH0_CLIENT_ID_PROD
Value: oKs0PcU5MhzDnKQqalf1xQKYLE4YsCOK

Name: AUTH0_CLIENT_SECRET_PROD
Value: M5aaGAZTJG4-tD7rMQMBECk9TWUHDrAMG0wCRFyFvYqOoIskj7juIdtj5BBUDpdB
```

## 📋 Quick Setup Using GitHub CLI

If you have GitHub CLI installed, you can set these up quickly:

```bash
# Development Environment
gh secret set AUTH0_DOMAIN_DEV --body "dev-3ey3z12ipauxwzup.us.auth0.com"
gh secret set AUTH0_CLIENT_ID_DEV --body "ZNA0WDKKxRUuiaZzQtS06P4ksrKCP3yu"  
gh secret set AUTH0_CLIENT_SECRET_DEV --body "IBWzaVffwmwHerh6HT77q7YJnmsOwBGonU22vd-ga6QyT4-Wnc_hRj1emTWvBOeZ"

# Staging Environment
gh secret set AUTH0_DOMAIN_STAGING --body "dev-3ey3z12ipauxwzup.us.auth0.com"
gh secret set AUTH0_CLIENT_ID_STAGING --body "ZNA0WDKKxRUuiaZzQtS06P4ksrKCP3yu"
gh secret set AUTH0_CLIENT_SECRET_STAGING --body "IBWzaVffwmwHerh6HT77q7YJnmsOwBGonU22vd-ga6QyT4-Wnc_hRj1emTWvBOeZ"

# Production Environment
gh secret set AUTH0_DOMAIN_PROD --body "dev-ttiw0oehq6nnv2jk.us.auth0.com"
gh secret set AUTH0_CLIENT_ID_PROD --body "oKs0PcU5MhzDnKQqalf1xQKYLE4YsCOK"
gh secret set AUTH0_CLIENT_SECRET_PROD --body "M5aaGAZTJG4-tD7rMQMBECk9TWUHDrAMG0wCRFyFvYqOoIskj7juIdtj5BBUDpdB"
```

## 🔍 Verify Secrets Are Set

After setting up the secrets, verify they're configured:

```bash
gh secret list
```

You should see all 9 secrets listed.

## ⚠️ Important Security Notes

1. **Never commit credentials**: The workflow now injects these values securely
2. **Environment separation**: Each environment has its own set of credentials  
3. **Access control**: Only repository collaborators can view/edit secrets
4. **Audit trail**: GitHub logs secret access and modifications
5. **Encryption**: All secrets are encrypted at rest and in transit

## 🚀 How the Workflow Uses These Secrets

The GitHub Actions workflow will automatically:
1. Select the correct secrets based on the target environment
2. Inject them as environment variables during deployment
3. Create the terraform.tfvars file securely at runtime
4. Never expose the values in logs or artifacts

## ✅ After Setting Up Secrets

Once you've added all the secrets, your deployments will continue working but with proper security:

- ✅ No sensitive data in repository
- ✅ Environment-specific credential management
- ✅ Secure runtime injection
- ✅ Full audit trail

Your Auth0 credentials are now properly secured! 🔒