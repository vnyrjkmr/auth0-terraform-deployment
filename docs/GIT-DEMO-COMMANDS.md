# 🎯 Git Commands Demo Guide

## 📋 **Demo Sequence Overview**
1. **Development Branch Deployment**
2. **Feature Branch → Development Integration** 
3. **Staging Tag Deployment**
4. **Production Tag Deployment**
5. **Hotfix Emergency Flow**

---

## 🔥 **DEMO 1: Development Branch Deployment**

### **Purpose:** Show development branch → development tenant deployment

```bash
# Step 1: Switch to development branch
git checkout development
git pull origin development

# Step 2: Create test content
echo "# Development Test - $(date)" > DEV-TEST-$(date +%Y%m%d-%H%M%S).md
echo "" >> DEV-TEST-$(date +%Y%m%d-%H%M%S).md
echo "Testing development branch deployment" >> DEV-TEST-$(date +%Y%m%d-%H%M%S).md
echo "Target: Development tenant (dev)" >> DEV-TEST-$(date +%Y%m%d-%H%M%S).md

# Step 3: Commit and push to trigger development deployment
git add .
git commit -m "demo: Development environment test deployment"
git push origin development

# Expected Result: Deploys to development tenant using config/dev.tfvars
```

**✅ Expected Outcome:** 
- Workflow triggers: "Deploy Auth0 Infrastructure"
- Environment: development
- Tenant: dev
- Config: config/dev.tfvars

---

## 🔥 **DEMO 2: Feature Branch → Development Integration**

### **Purpose:** Show feature development workflow

```bash
# Step 1: Create feature branch from development
git checkout development
git pull origin development
git checkout -b feature/team-demo-auth-$(date +%H%M)

# Step 2: Develop feature
echo "# Feature: Enhanced Auth Flow - $(date)" > FEATURE-AUTH-$(date +%Y%m%d-%H%M%S).md
echo "" >> FEATURE-AUTH-$(date +%Y%m%d-%H%M%S).md
echo "## Changes:" >> FEATURE-AUTH-$(date +%Y%m%d-%H%M%S).md
echo "- Multi-factor authentication improvements" >> FEATURE-AUTH-$(date +%Y%m%d-%H%M%S).md
echo "- Enhanced session management" >> FEATURE-AUTH-$(date +%Y%m%d-%H%M%S).md
echo "- Performance optimizations" >> FEATURE-AUTH-$(date +%Y%m%d-%H%M%S).md

# Step 3: Commit feature work
git add .
git commit -m "feat: Enhanced authentication with MFA support

- Added multi-factor authentication
- Improved session management  
- Performance optimizations
- Ready for integration testing"

# Step 4: Push feature branch
git push origin feature/team-demo-auth-$(date +%H%M)

# Step 5: Merge to development (simulates PR approval)
git checkout development
git merge feature/team-demo-auth-$(date +%H%M) --no-ff -m "Merge feature: Enhanced authentication flow"

# Step 6: Push merged changes to trigger development deployment
git push origin development

# Step 7: Cleanup feature branch
git branch -d feature/team-demo-auth-$(date +%H%M)
git push origin --delete feature/team-demo-auth-$(date +%H%M)
```

**✅ Expected Outcome:**
- Feature developed in isolated branch
- Merged to development → triggers deployment to dev tenant
- Feature available for testing in development environment

---

## 🔥 **DEMO 3: Staging Tag Deployment (v5.0 style from screenshot)**

### **Purpose:** Show staging tag → staging tenant deployment

```bash
# Step 1: Prepare staging from development
git checkout development
git pull origin development

# Step 2: Create staging release content
echo "# Staging Release v5.$(date +%m) - $(date)" > STAGING-v5.$(date +%m)-$(date +%Y%m%d-%H%M%S).md
echo "" >> STAGING-v5.$(date +%m)-$(date +%Y%m%d-%H%M%S).md
echo "## Pre-Production Validation Release" >> STAGING-v5.$(date +%m)-$(date +%Y%m%d-%H%M%S).md
echo "Target: Staging tenant for final testing" >> STAGING-v5.$(date +%m)-$(date +%Y%m%d-%H%M%S).md
echo "Features ready for production validation" >> STAGING-v5.$(date +%m)-$(date +%Y%m%d-%H%M%S).md

# Step 3: Commit staging preparation
git add .
git commit -m "release: Prepare staging release v5.$(date +%m)

- All development features integrated
- Ready for pre-production validation  
- Staging deployment via tag trigger"

# Step 4: Create and push staging tag (like v5.0-staging in screenshot)
STAGING_TAG="v5.$(date +%m)-staging"
git tag -a $STAGING_TAG -m "Staging Release v5.$(date +%m)

🔵 Staging deployment for pre-production testing
🎯 Target: Staging tenant (staging)
📁 Config: config/qa.tfvars

Features for validation:
- Enhanced authentication flow
- Multi-factor authentication
- Performance improvements"

git push origin $STAGING_TAG
```

**✅ Expected Outcome:**
- Tag triggers workflow: "Deploy Auth0 Infrastructure" 
- Environment: staging
- Tenant: staging
- Config: config/qa.tfvars

---

## 🔥 **DEMO 4: Production Tag Deployment (v2.1, v3.1 style from screenshot)**

### **Purpose:** Show production tag → production tenant deployment

```bash
# Step 1: Switch to master for production release
git checkout master
git pull origin master

# Step 2: Create production release content  
PROD_VERSION="$(date +%m.%d)"
echo "# Production Release v$PROD_VERSION - $(date)" > PRODUCTION-v$PROD_VERSION-$(date +%Y%m%d-%H%M%S).md
echo "" >> PRODUCTION-v$PROD_VERSION-$(date +%Y%m%d-%H%M%S).md
echo "## Production Deployment" >> PRODUCTION-v$PROD_VERSION-$(date +%Y%m%d-%H%M%S).md
echo "Validated in development and staging" >> PRODUCTION-v$PROD_VERSION-$(date +%Y%m%d-%H%M%S).md
echo "Ready for production deployment" >> PRODUCTION-v$PROD_VERSION-$(date +%Y%m%d-%H%M%S).md

# Step 3: Commit production release
git add .
git commit -m "release: Production release v$PROD_VERSION

- All features tested in development
- Staging validation completed
- Security assessments passed
- Performance benchmarks met"

# Step 4: Create and push production tag (like v2.1, v3.1 in screenshot)
PROD_TAG="v$PROD_VERSION"
git tag -a $PROD_TAG -m "Production Release v$PROD_VERSION

🚀 Production deployment
🎯 Target: Production tenant (prod)  
📁 Config: config/prod.tfvars

Release includes:
- Enhanced authentication features
- Security improvements
- Performance optimizations
- Full validation completed"

git push origin $PROD_TAG
```

**✅ Expected Outcome:**
- Tag triggers workflow: "Deploy Auth0 Infrastructure"
- Environment: production  
- Tenant: prod
- Config: config/prod.tfvars

---

## 🔥 **DEMO 5: Hotfix Emergency Flow**

### **Purpose:** Show emergency hotfix → staging → production flow

```bash
# Step 1: Create hotfix from master (current production)
git checkout master
git pull origin master
HOTFIX_BRANCH="hotfix/critical-security-$(date +%H%M)"
git checkout -b $HOTFIX_BRANCH

# Step 2: Create critical fix documentation
echo "# 🚨 CRITICAL HOTFIX - $(date)" > HOTFIX-SECURITY-$(date +%Y%m%d-%H%M%S).md
echo "" >> HOTFIX-SECURITY-$(date +%Y%m%d-%H%M%S).md
echo "## Emergency Security Patch" >> HOTFIX-SECURITY-$(date +%Y%m%d-%H%M%S).md
echo "Critical vulnerability discovered" >> HOTFIX-SECURITY-$(date +%Y%m%d-%H%M%S).md
echo "Immediate hotfix required" >> HOTFIX-SECURITY-$(date +%Y%m%d-%H%M%S).md
echo "" >> HOTFIX-SECURITY-$(date +%Y%m%d-%H%M%S).md
echo "## Security Fix Applied:" >> HOTFIX-SECURITY-$(date +%Y%m%d-%H%M%S).md
echo "- Enhanced JWT validation" >> HOTFIX-SECURITY-$(date +%Y%m%d-%H%M%S).md
echo "- Fixed authentication bypass" >> HOTFIX-SECURITY-$(date +%Y%m%d-%H%M%S).md
echo "- Added security headers" >> HOTFIX-SECURITY-$(date +%Y%m%d-%H%M%S).md

# Step 3: Commit critical fix
git add .
git commit -m "🚨 CRITICAL HOTFIX: Security vulnerability patch

- Fixed authentication bypass vulnerability
- Enhanced JWT token validation
- Added security monitoring
- Emergency deployment required

Priority: P0-Critical
Approval: Security team emergency response"

# Step 4: Push hotfix → triggers STAGING deployment (emergency validation)
git push origin $HOTFIX_BRANCH

echo "🚨 HOTFIX PUSHED → STAGING DEPLOYMENT"
echo "⚡ This bypasses development for emergency speed"
echo "🧪 Validates in staging before production"

# Step 5: After staging validation, merge to master for production
echo ""
echo "⏳ [Simulating: Staging validation successful]"
echo "⏳ [Simulating: Security team approval received]"
echo ""
echo "🚀 PRODUCTION DEPLOYMENT COMMANDS:"
echo "git checkout master"
echo "git merge $HOTFIX_BRANCH --no-ff -m 'Emergency hotfix: Critical security patch'"
echo "git push origin master  # Triggers production deployment"
echo "git branch -d $HOTFIX_BRANCH"
```

**✅ Expected Outcome:**
- Hotfix push → staging deployment (config/qa.tfvars)
- After validation → merge to master → production deployment  
- Emergency bypass of normal development flow

---

## 📊 **Monitoring Commands (Use During Demo)**

```bash
# Check recent workflow runs
gh run list --limit 5

# Monitor specific deployment  
gh run view <RUN_ID> --log | grep -E "(Environment|Tenant|Apply complete)"

# Check current tags
git tag --sort=-version:refname | head -10

# Show branch status
git branch -a

# Repository status
git status
```

---

## 🎯 **Demo Flow Summary**

| **Demo** | **Trigger** | **Target Environment** | **Config File** |
|----------|-------------|------------------------|-----------------|
| **1** | Development branch push | Development tenant | config/dev.tfvars |
| **2** | Feature → Development merge | Development tenant | config/dev.tfvars |  
| **3** | v*.*-staging tag | Staging tenant | config/qa.tfvars |
| **4** | v*.* tag | Production tenant | config/prod.tfvars |
| **5** | Hotfix branch push | Staging tenant → Production | config/qa.tfvars → config/prod.tfvars |

## 📋 **Expected GitHub Actions Results**

Each Git operation should trigger the "Deploy Auth0 Infrastructure" workflow:

1. **Development**: `development` branch → dev tenant
2. **Feature**: Merged to `development` → dev tenant  
3. **Staging**: `v5.*-staging` tag → staging tenant
4. **Production**: `v*.*` tag → production tenant
5. **Hotfix**: `hotfix/*` branch → staging tenant

**Monitor**: https://github.com/vnyrjkmr/auth0-terraform-deployment/actions

---

**Demo Duration**: ~30 minutes  
**Commands**: Simple Git operations  
**Outcome**: Live multi-environment Auth0 deployments