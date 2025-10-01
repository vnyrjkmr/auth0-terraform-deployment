# 🎯 Auth0 Terraform Deployment Flow - Team Demo Script

## 📋 **Demo Overview**
This demo showcases the complete GitFlow branching strategy with Auth0 multi-tenant deployments as illustrated in the architecture diagram.

## 🎬 **Demo Structure** 
1. **Environment Setup & Overview** (5 minutes)
2. **Branch-Based Deployments** (10 minutes)  
3. **Tag-Based Deployments** (8 minutes)
4. **Hotfix Emergency Flow** (5 minutes)
5. **Monitoring & Verification** (7 minutes)

---

## 🏗️ **PART 1: Environment Setup & Overview** 

### **Step 1.1: Show Current Repository State**
```powershell
# Display repository structure
Write-Host "🏢 Repository Structure:" -ForegroundColor Cyan
Get-ChildItem -Path . -Name | Sort-Object

Write-Host "`n📁 Organized Structure:" -ForegroundColor Cyan
Write-Host "├── config/    - Environment configurations" -ForegroundColor Green
Write-Host "├── docs/      - Documentation" -ForegroundColor Green  
Write-Host "├── scripts/   - PowerShell automation" -ForegroundColor Green
Write-Host "└── .github/   - Deployment workflows" -ForegroundColor Green
```

### **Step 1.2: Show Multi-Environment Configuration**
```powershell
Write-Host "`n🎯 Multi-Tenant Environment Setup:" -ForegroundColor Cyan
Write-Host "Development  → dev tenant      (config/dev.tfvars)" -ForegroundColor Yellow
Write-Host "Staging      → staging tenant  (config/qa.tfvars)" -ForegroundColor Blue  
Write-Host "Production   → prod tenant     (config/prod.tfvars)" -ForegroundColor Red

# Show actual configurations
Get-Content config/dev.tfvars | Select-String "environment|tenant_name"
Get-Content config/qa.tfvars | Select-String "environment|tenant_name"  
Get-Content config/prod.tfvars | Select-String "environment|tenant_name"
```

### **Step 1.3: Show Workflow Triggers**
```powershell
Write-Host "`n⚡ Deployment Triggers:" -ForegroundColor Cyan
Write-Host "📌 Branch Pushes: main, development, feature/*, hotfix/*, release/*" -ForegroundColor White
Write-Host "🏷️  Tags: v*.*, v*.*.*" -ForegroundColor White
Write-Host "🔧 Manual: workflow_dispatch" -ForegroundColor White
```

---

## 🌿 **PART 2: Branch-Based Deployments**

### **Step 2.1: Development Branch Deployment**
```powershell
Write-Host "`n🔥 DEMO: Development Branch → Development Tenant" -ForegroundColor Magenta

# Switch to development branch
git checkout development
git pull origin development

# Make a test change
$testContent = @"
# Development Test - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

This is a test deployment to development environment.
Triggered by: Development branch push
Target: Development Tenant (dev)
"@

$testContent | Out-File -FilePath "DEV-TEST-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

# Commit and push
git add .
git commit -m "test: Development environment deployment demo"
git push origin development

Write-Host "✅ Development deployment triggered!" -ForegroundColor Green
Write-Host "🔍 Monitor: https://github.com/vnyrjkmr/auth0-terraform-deployment/actions" -ForegroundColor Blue
```

### **Step 2.2: Feature Branch Workflow**  
```powershell
Write-Host "`n🔥 DEMO: Feature Branch → Development Integration" -ForegroundColor Magenta

# Create feature branch
$featureName = "feature/team-demo-$(Get-Date -Format 'yyyyMMdd-HHmm')"
git checkout -b $featureName

# Create feature content
$featureContent = @"
# Feature Demo - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

## Feature: Team Demo Integration

### Changes:
- New authentication flow
- Enhanced user experience  
- Security improvements

### Testing:
- Unit tests: ✅ Passed
- Integration tests: ✅ Passed
- Security scan: ✅ Passed
"@

$featureContent | Out-File -FilePath "FEATURE-DEMO-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

# Commit feature
git add .
git commit -m "feat: Add team demo authentication feature"
git push origin $featureName

Write-Host "✅ Feature branch created: $featureName" -ForegroundColor Green
Write-Host "📝 Next: Create PR to development branch" -ForegroundColor Yellow
```

### **Step 2.3: Master Branch → Production**
```powershell
Write-Host "`n🔥 DEMO: Master Branch → Production Tenant + Auto-Tag" -ForegroundColor Magenta

# Switch to master and merge development
git checkout master
git pull origin master

# Simulate development merge (in real scenario, this would be via PR)
Write-Host "⚠️  Simulating: Development → Master merge (normally via PR)" -ForegroundColor Yellow

$prodContent = @"
# Production Release - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

## Release Notes:
- All development features tested and approved
- Security validations completed
- Performance benchmarks met

## Deployment:
- Target: Production Tenant (prod)
- Auto-tag: Will be created after successful deployment
- Environment: production
"@

$prodContent | Out-File -FilePath "PRODUCTION-RELEASE-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

git add .
git commit -m "release: Production deployment with integrated features"
git push origin master

Write-Host "✅ Production deployment triggered!" -ForegroundColor Green
Write-Host "🏷️  Auto-tag will be created after successful deployment" -ForegroundColor Cyan
```

---

## 🏷️ **PART 3: Tag-Based Deployments**

### **Step 3.1: Production Tag Deployment**
```powershell
Write-Host "`n🔥 DEMO: Production Tags → Production Tenant" -ForegroundColor Magenta

# Create production tags like in screenshot (v2.1, v3.1)
$prodTag = "v$(Get-Date -Format 'M.d')-production"

git checkout master
git tag -a $prodTag -m "Production release $prodTag - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git push origin $prodTag

Write-Host "✅ Production tag created: $prodTag" -ForegroundColor Green
Write-Host "🎯 This will deploy to: Production Tenant" -ForegroundColor Red
```

### **Step 3.2: Staging Tag Deployment** 
```powershell
Write-Host "`n🔥 DEMO: Staging Tags → Staging Tenant (v5.0 style)" -ForegroundColor Magenta

# Create staging tag like in screenshot (v5.0 staging)
$stagingTag = "v5.$(Get-Date -Format 'M')-staging"

git checkout development
git tag -a $stagingTag -m "Staging release $stagingTag - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git push origin $stagingTag

Write-Host "✅ Staging tag created: $stagingTag" -ForegroundColor Green
Write-Host "🎯 This will deploy to: Staging Tenant" -ForegroundColor Blue
```

---

## 🚨 **PART 4: Hotfix Emergency Flow**

### **Step 4.1: Critical Hotfix Scenario**
```powershell
Write-Host "`n🔥 DEMO: Hotfix Branch → Staging (Emergency Path)" -ForegroundColor Red

# Create hotfix branch
$hotfixName = "hotfix/critical-security-fix-$(Get-Date -Format 'yyyyMMdd-HHmm')"
git checkout master
git checkout -b $hotfixName

# Create hotfix content
$hotfixContent = @"
# 🚨 CRITICAL HOTFIX - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

## Issue: 
Critical security vulnerability detected in authentication flow

## Fix:
- Updated JWT token validation
- Enhanced session management
- Patched security headers

## Testing:
- Security scan: ✅ PASSED
- Vulnerability assessment: ✅ CLEAR
- Performance impact: ✅ MINIMAL

## Deployment Path:
Hotfix Branch → Staging → Master → Production
"@

$hotfixContent | Out-File -FilePath "HOTFIX-SECURITY-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

git add .
git commit -m "hotfix: Critical security vulnerability patch"
git push origin $hotfixName

Write-Host "✅ Hotfix branch created: $hotfixName" -ForegroundColor Green
Write-Host "⚡ This triggers: Staging deployment (bypass normal flow)" -ForegroundColor Yellow
Write-Host "📋 Next Steps: Test in staging → Merge to master → Production" -ForegroundColor Cyan
```

---

## 📊 **PART 5: Monitoring & Verification**

### **Step 5.1: Real-Time Monitoring Commands**
```powershell
Write-Host "`n📊 MONITORING COMMANDS:" -ForegroundColor Cyan

# Function to monitor workflows
function Show-DeploymentStatus {
    Write-Host "`n🔍 Current Workflow Runs:" -ForegroundColor Yellow
    gh run list --limit 5 --json displayTitle,status,conclusion,createdAt,url | 
    ConvertFrom-Json | 
    ForEach-Object {
        $status = if ($_.conclusion) { $_.conclusion } else { $_.status }
        $color = switch ($status) {
            "success" { "Green" }
            "failure" { "Red" }  
            "in_progress" { "Yellow" }
            "queued" { "Cyan" }
            default { "White" }
        }
        Write-Host "[$status] $($_.displayTitle)" -ForegroundColor $color
        Write-Host "   Created: $($_.createdAt)" -ForegroundColor Gray
        Write-Host "   URL: $($_.url)" -ForegroundColor Blue
        Write-Host ""
    }
}

# Function to show specific run details
function Show-RunDetails($runId) {
    Write-Host "`n📋 Run Details for ID: $runId" -ForegroundColor Cyan
    gh run view $runId --log | Select-String -Pattern "(Environment|Tenant|Apply complete|Successfully deployed)" | Select-Object -Last 10
}

# Function to show current tags
function Show-Tags {
    Write-Host "`n🏷️ Current Tags:" -ForegroundColor Cyan
    git tag --sort=-version:refname | Select-Object -First 10 | ForEach-Object {
        $tagType = if ($_ -like "*production*" -or $_ -match "^v\d+\.\d+$") { 
            "[PRODUCTION]" 
        } elseif ($_ -like "*staging*") { 
            "[STAGING]" 
        } else { 
            "[OTHER]" 
        }
        Write-Host "$tagType $_" -ForegroundColor $(if ($tagType -eq "[PRODUCTION]") {"Red"} elseif ($tagType -eq "[STAGING]") {"Blue"} else {"Gray"})
    }
}
```

### **Step 5.2: Environment Verification**
```powershell
# Show current environment states
function Show-EnvironmentStatus {
    Write-Host "`n🌍 Environment Status:" -ForegroundColor Cyan
    
    Write-Host "`n🔧 Development Environment:" -ForegroundColor Yellow
    Write-Host "   Tenant: dev" -ForegroundColor Gray
    Write-Host "   Config: config/dev.tfvars" -ForegroundColor Gray
    Write-Host "   Last Deploy: [Check GitHub Actions]" -ForegroundColor Gray
    
    Write-Host "`n🔵 Staging Environment:" -ForegroundColor Blue
    Write-Host "   Tenant: staging" -ForegroundColor Gray
    Write-Host "   Config: config/qa.tfvars" -ForegroundColor Gray
    Write-Host "   Last Deploy: [Check GitHub Actions]" -ForegroundColor Gray
    
    Write-Host "`n🔴 Production Environment:" -ForegroundColor Red
    Write-Host "   Tenant: prod" -ForegroundColor Gray
    Write-Host "   Config: config/prod.tfvars" -ForegroundColor Gray
    Write-Host "   Last Deploy: [Check GitHub Actions]" -ForegroundColor Gray
}
```

---

## 🧹 **PART 6: Demo Cleanup**

### **Step 6.1: Cleanup Commands**
```powershell
Write-Host "`n🧹 DEMO CLEANUP:" -ForegroundColor Magenta

# Function to clean up demo artifacts
function Clear-DemoArtifacts {
    Write-Host "Removing demo files..." -ForegroundColor Yellow
    Get-ChildItem -Path . -Filter "*DEMO*" -Name | Remove-Item -Verbose
    Get-ChildItem -Path . -Filter "*TEST*" -Name | Remove-Item -Verbose
    Get-ChildItem -Path . -Filter "*HOTFIX*" -Name | Remove-Item -Verbose
    Get-ChildItem -Path . -Filter "*FEATURE*" -Name | Remove-Item -Verbose
    Get-ChildItem -Path . -Filter "*PRODUCTION*" -Name | Remove-Item -Verbose
    
    Write-Host "✅ Demo artifacts cleaned up" -ForegroundColor Green
}

# Function to delete demo branches (use carefully!)
function Remove-DemoBranches {
    Write-Host "⚠️  Removing demo branches..." -ForegroundColor Red
    git branch -D $(git branch --list "feature/*demo*") 2>$null
    git branch -D $(git branch --list "hotfix/*demo*") 2>$null
    
    Write-Host "✅ Demo branches cleaned up" -ForegroundColor Green
}

# Function to return to clean state
function Reset-DemoEnvironment {
    git checkout development
    git pull origin development
    Clear-DemoArtifacts
    Write-Host "✅ Ready for next demo!" -ForegroundColor Green
}
```

---

## 🎯 **DEMO EXECUTION CHECKLIST**

### **Pre-Demo Setup (5 minutes before):**
- [ ] Open VS Code with repository
- [ ] Open PowerShell terminal
- [ ] Open GitHub Actions page in browser
- [ ] Verify all environments are accessible
- [ ] Load this script file

### **During Demo Flow:**
1. [ ] **Environment Overview** - Show structure and configuration
2. [ ] **Development Flow** - Branch push → Development deployment  
3. [ ] **Feature Integration** - Feature branch → Development merge
4. [ ] **Production Release** - Master push → Production + Auto-tag
5. [ ] **Tag Deployments** - Production and Staging tags
6. [ ] **Hotfix Emergency** - Critical fix → Staging bypass
7. [ ] **Live Monitoring** - Real-time workflow status
8. [ ] **Verification** - Check deployment results

### **Key Talking Points:**
- **GitFlow Strategy**: Structured branching for team collaboration
- **Multi-Tenant**: Separate Auth0 environments for dev/staging/prod  
- **Automated Deployments**: No manual intervention needed
- **Security & Compliance**: Controlled promotion path
- **Emergency Response**: Hotfix path for critical issues
- **Monitoring**: Full visibility into deployment pipeline

---

**Demo Duration**: ~35 minutes  
**Audience**: Development team, DevOps, stakeholders  
**Prerequisites**: Access to GitHub repository and Actions