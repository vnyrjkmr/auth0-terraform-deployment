# 🎯 Demo Script 1: Development Branch Deployment
# Purpose: Demonstrate Development branch → Development tenant deployment

Write-Host "🔥 DEMO 1: Development Branch → Development Tenant" -ForegroundColor Magenta
Write-Host "=" * 60 -ForegroundColor Cyan

# Step 1: Switch to development branch
Write-Host "`n📍 Step 1: Switch to development branch" -ForegroundColor Yellow
git checkout development
git pull origin development
Write-Host "✅ On development branch" -ForegroundColor Green

# Step 2: Create test content
Write-Host "`n📍 Step 2: Create development test content" -ForegroundColor Yellow
$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$filename = "DEV-DEPLOYMENT-TEST-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"

$testContent = @"
# Development Environment Test - $timestamp

## Test Scenario: Development Branch Deployment

### Trigger: Development branch push
### Target: Development Tenant (dev environment)
### Config: config/dev.tfvars
### Expected Outcome: Deployment to Auth0 dev tenant

### Test Changes:
- Updated user authentication flow
- Enhanced error handling
- Improved logging configuration

### Verification Steps:
1. Check GitHub Actions workflow execution
2. Verify deployment to development tenant
3. Validate Auth0 configuration changes
4. Test authentication flow

---
**Demo executed by**: Team Demo Script
**Timestamp**: $timestamp
"@

$testContent | Out-File -FilePath $filename -Encoding UTF8
Write-Host "✅ Created test file: $filename" -ForegroundColor Green

# Step 3: Commit and push
Write-Host "`n📍 Step 3: Commit and push to trigger deployment" -ForegroundColor Yellow
git add .
git commit -m "demo: Development environment deployment test - $(Get-Date -Format 'HH:mm:ss')"

Write-Host "`n🚀 Pushing to development branch..." -ForegroundColor Cyan
git push origin development

Write-Host "`n✅ Development deployment triggered!" -ForegroundColor Green
Write-Host "🔍 Monitor at: https://github.com/vnyrjkmr/auth0-terraform-deployment/actions" -ForegroundColor Blue

# Step 4: Show monitoring command
Write-Host "`n📊 Monitor deployment status:" -ForegroundColor Yellow
Write-Host "gh run list --limit 3" -ForegroundColor Gray
Write-Host "`nTo view detailed logs:" -ForegroundColor Yellow  
Write-Host "gh run view [RUN_ID] --log" -ForegroundColor Gray

Write-Host "`n🎯 Expected Result:" -ForegroundColor Magenta
Write-Host "✅ Workflow: Deploy Auth0 Infrastructure" -ForegroundColor White
Write-Host "✅ Environment: development" -ForegroundColor White
Write-Host "✅ Tenant: dev" -ForegroundColor White
Write-Host "✅ Config: config/dev.tfvars" -ForegroundColor White

Write-Host "`n" + "=" * 60 -ForegroundColor Cyan
Write-Host "Demo 1 Complete - Ready for next scenario!" -ForegroundColor Green