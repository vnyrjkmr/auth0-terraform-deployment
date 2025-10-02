# 🎯 Team Demo - Git Commands Only

## 📋 Demo Flow: Copy and paste these commands

Added changes in development
I want to deploy dev branch in to dev


Produvtion deployment

chnge in code
## 🔥 DEMO 1: Development Branch Deployment

```bash
# Switch to development and create test content
git checkout development
git pull origin development

# Create development test file
echo "# Development Test - $(Get-Date)" > "DEV-TEST-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
echo "Target: Development tenant (dev)" >> "DEV-TEST-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

# Deploy to development
git add .
git commit -m "demo: Development environment test"
git push origin development
```
**Result:** Triggers deployment to **development tenant** using `config/dev.tfvars`

---

## 🔥 DEMO 2: Feature Branch → Development

```bash
# Create feature branch
git checkout development
git pull origin development
git checkout -b "feature/demo-auth-$(Get-Date -Format 'HHmm')"

# Create feature content
echo "# Feature: Enhanced Auth - $(Get-Date)" > "FEATURE-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
echo "- Multi-factor authentication" >> "FEATURE-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
echo "- Performance improvements" >> "FEATURE-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

# Commit feature
git add .
git commit -m "feat: Enhanced authentication with MFA"
git push origin "feature/demo-auth-$(Get-Date -Format 'HHmm')"

# Merge to development
git checkout development
git merge "feature/demo-auth-$(Get-Date -Format 'HHmm')" --no-ff -m "Merge: Enhanced auth feature"
git push origin development

# Cleanup
git branch -d "feature/demo-auth-$(Get-Date -Format 'HHmm')"
```
**Result:** Feature merged to development → triggers **development tenant** deployment

---

## 🔥 DEMO 3: Staging Tag (v5.0-staging style)

```bash
# Prepare staging release from development
git checkout development
git pull origin development

# Create staging content
echo "# Staging Release v5.$(Get-Date -Format 'M') - $(Get-Date)" > "STAGING-v5.$(Get-Date -Format 'M')-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
echo "Pre-production validation release" >> "STAGING-v5.$(Get-Date -Format 'M')-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

# Commit and tag for staging
git add .
git commit -m "release: Staging v5.$(Get-Date -Format 'M') for validation"
git tag -a "v5.$(Get-Date -Format 'M')-staging" -m "Staging release for testing"
git push origin "v5.$(Get-Date -Format 'M')-staging"
```
**Result:** Staging tag triggers deployment to **staging tenant** using `config/qa.tfvars`

---

## 🔥 DEMO 4: Production Tag (v2.1, v3.1 style)

```bash
# Switch to master for production
git checkout master
git pull origin master

# Create production release
echo "# Production Release v$(Get-Date -Format 'M.d') - $(Get-Date)" > "PRODUCTION-v$(Get-Date -Format 'M.d')-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
echo "Validated features ready for production" >> "PRODUCTION-v$(Get-Date -Format 'M.d')-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

# Commit and create production tag
git add .
git commit -m "release: Production v$(Get-Date -Format 'M.d')"
git tag -a "v$(Get-Date -Format 'M.d')" -m "Production release v$(Get-Date -Format 'M.d')"
git push origin "v$(Get-Date -Format 'M.d')"
```
**Result:** Production tag triggers deployment to **production tenant** using `config/prod.tfvars`

---

## 🔥 DEMO 5: Emergency Hotfix

```bash
# Create hotfix from master
git checkout master
git pull origin master
git checkout -b "hotfix/security-$(Get-Date -Format 'HHmm')"

# Create critical fix
echo "# 🚨 CRITICAL HOTFIX - $(Get-Date)" > "HOTFIX-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
echo "Emergency security vulnerability patch" >> "HOTFIX-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
echo "- Fixed authentication bypass" >> "HOTFIX-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

# Deploy hotfix to staging first
git add .
git commit -m "🚨 CRITICAL: Security vulnerability patch"
git push origin "hotfix/security-$(Get-Date -Format 'HHmm')"
```
**Result:** Hotfix branch triggers **staging deployment** for emergency validation

**After staging validation:**
```bash
# Merge to master for production (after staging approval)
git checkout master
git merge "hotfix/security-$(Get-Date -Format 'HHmm')" --no-ff -m "Emergency security patch"
git push origin master
git branch -d "hotfix/security-$(Get-Date -Format 'HHmm')"
```
**Result:** Master push triggers **production deployment**

---

## 📊 Monitoring Commands

```bash
# Check recent deployments
gh run list --limit 5

# Monitor specific deployment
gh run view [RUN_ID] --log

# Check deployment status
gh run list --status in_progress

# View logs for key events  
gh run view [RUN_ID] --log | Select-String "Environment|Tenant|Apply complete"

# Show current tags
git tag --sort=-version:refname | Select-Object -First 10

# Repository status
git status
git branch -a
```

---

## 🎯 Expected Results Summary

| **Command** | **Trigger** | **Target** | **Config** |
|-------------|-------------|------------|------------|
| `git push origin development` | Development branch | Dev tenant | `config/dev.tfvars` |
| Feature merge to development | Development merge | Dev tenant | `config/dev.tfvars` |
| `git push origin v5.X-staging` | Staging tag | Staging tenant | `config/qa.tfvars` |
| `git push origin vX.Y` | Production tag | Production tenant | `config/prod.tfvars` |
| `git push origin hotfix/*` | Hotfix branch | Staging tenant | `config/qa.tfvars` |

---

## 🔍 Success Indicators

Look for these in GitHub Actions:
- ✅ "Deploy Auth0 Infrastructure" workflow triggered
- ✅ "Apply complete! Resources: X added, Y changed, Z destroyed"  
- ✅ "Successfully deployed Auth0 infrastructure"
- ✅ Correct Environment and Tenant in logs
- ✅ No ERROR or FAILED messages

**Monitor at:** https://github.com/vnyrjkmr/auth0-terraform-deployment/actions

---

**Demo Duration:** ~25 minutes  
**Copy & paste these commands in sequence for live demonstration**