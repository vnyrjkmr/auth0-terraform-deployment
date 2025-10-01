# 🎯 Team Demo - Quick Reference Card

## 📋 **Demo Execution Order (35 minutes total)**

### **🏗️ Pre-Demo Setup (5 min)**
```powershell
# 1. Open VS Code with repository
# 2. Open PowerShell terminal  
# 3. Open GitHub Actions page: https://github.com/vnyrjkmr/auth0-terraform-deployment/actions
# 4. Verify current branch
git status
git branch --show-current
```

### **🎬 Demo Flow**

| **Demo** | **Script** | **Time** | **Purpose** |
|----------|------------|----------|-------------|
| **1** | `.\scripts\demo-1-development.ps1` | 5 min | Development branch → Dev tenant |
| **2** | `.\scripts\demo-2-feature.ps1` | 7 min | Feature workflow → Dev integration |
| **3** | `.\scripts\demo-3-production-tag.ps1` | 5 min | v*.* tags → Production tenant |
| **4** | `.\scripts\demo-4-staging-tag.ps1` | 5 min | v*.*-staging → Staging tenant |
| **5** | `.\scripts\demo-5-hotfix.ps1` | 8 min | Emergency hotfix → Staging |
| **6** | `.\scripts\demo-6-monitoring.ps1` | 5 min | Real-time monitoring & verification |

### **🧹 Post-Demo Cleanup**
```powershell
.\scripts\demo-7-cleanup.ps1
```

---

## 🎯 **Key Demo Points**

### **Branching Strategy (Per Screenshot)**
- **Master** → Production deployments + auto-tags
- **Development** → Development environment  
- **Feature/** → Development integration
- **Hotfix/** → Staging (emergency bypass)
- **Tags v*.*** → Production deployments
- **Tags v*.*-staging** → Staging deployments

### **Multi-Tenant Architecture**
- **Production Tenant** (`prod`) ← Master branch, v*.* tags
- **Staging Tenant** (`staging`) ← Hotfix/release branches, v*.*-staging tags  
- **Development Tenant** (`dev`) ← Development branch, feature merges

### **Configuration Files**
- **config/prod.tfvars** → Production environment
- **config/qa.tfvars** → Staging environment
- **config/dev.tfvars** → Development environment

---

## 🔍 **Live Monitoring Commands**

### **Quick Status Check**
```powershell
# Show recent deployments
gh run list --limit 5

# Monitor specific deployment
gh run view <RUN_ID> --log | Select-String "Environment|Apply complete"

# Check current tags
git tag --sort=-version:refname | Select-Object -First 10
```

### **Environment Verification**
```powershell
# Check configurations
Get-Content config/*.tfvars | Select-String "environment|tenant"

# Show active branches
git branch -a

# Repository status
git status
```

---

## 🎙️ **Speaking Points**

### **Introduction (2 min)**
- "Today we'll demonstrate our GitFlow-based Auth0 deployment pipeline"
- "This shows how we manage multi-tenant Auth0 infrastructure across dev/staging/production"
- "The flow follows industry best practices for safe, controlled deployments"

### **During Each Demo**
1. **Development Flow**: "Normal day-to-day development work"
2. **Feature Integration**: "How team collaboration works with pull requests" 
3. **Production Tags**: "Controlled production releases via semantic versioning"
4. **Staging Tags**: "Pre-production validation environment"
5. **Emergency Hotfix**: "Critical issue response - bypasses normal flow for speed"
6. **Monitoring**: "Full visibility and traceability of all deployments"

### **Key Benefits**
- ✅ **Automated**: No manual deployments
- ✅ **Safe**: Controlled promotion path  
- ✅ **Traceable**: Full deployment history
- ✅ **Fast**: Emergency response capability
- ✅ **Scalable**: Multi-environment support
- ✅ **Compliant**: Audit trail and approvals

---

## ⚡ **Quick Commands Reference**

### **Branch Operations**
```powershell
git checkout development          # Switch to development
git checkout -b feature/name      # Create feature branch
git checkout -b hotfix/name       # Create hotfix branch  
git merge --no-ff branch-name     # Merge with commit
```

### **Tag Operations**
```powershell
git tag -a v1.0 -m "message"     # Create production tag
git tag -a v5.0-staging -m "msg" # Create staging tag
git push origin v1.0             # Push tag (triggers deployment)
git tag --list --sort=-version:refname  # List tags
```

### **Monitoring**
```powershell
gh run list                       # List workflows
gh run view RUN_ID               # View specific run
gh run view RUN_ID --log         # View run logs
```

---

## 🚨 **Demo Safety Tips**

### **Before Starting**
- [ ] Verify you have GitHub Actions access
- [ ] Confirm all environments are accessible
- [ ] Check no critical deployments are running
- [ ] Have rollback plan ready

### **During Demo**
- ⚠️ **Use demo branches/tags only** (don't affect production)
- ⚠️ **Monitor deployments** (watch for failures)  
- ⚠️ **Explain what's happening** (narrate the process)
- ⚠️ **Be ready to skip** (if deployments are slow)

### **After Demo**
- [ ] Run cleanup script to remove demo artifacts
- [ ] Verify production environment is unchanged
- [ ] Reset to development branch
- [ ] Confirm no demo branches/tags remain

---

## 🎯 **Success Criteria**

### **Team Should Understand:**
- ✅ GitFlow branching strategy
- ✅ Multi-environment deployment flow  
- ✅ Tag-based production releases
- ✅ Emergency hotfix procedures
- ✅ Monitoring and verification process
- ✅ Auth0 multi-tenant management

### **Questions to Expect:**
- "What happens if a deployment fails?"
- "How do we rollback a production deployment?"  
- "Can we deploy to staging without going through development?"
- "What's the approval process for production releases?"
- "How do we handle database schema changes?"

---

**Demo Duration**: 35 minutes  
**Audience**: Development team, DevOps, stakeholders  
**Environment**: VS Code + PowerShell + GitHub Actions  
**Outcome**: Team understands complete deployment pipeline