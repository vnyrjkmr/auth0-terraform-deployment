# Manual GitHub Environments Setup Guide
# Use this if the PowerShell automation script has issues

Write-Host "🚀 Manual GitHub Environments Setup for Auth0 Terraform Deployment" -ForegroundColor Blue
Write-Host "Repository: vnyrjkmr/auth0-terraform-deployment" -ForegroundColor Blue

Write-Host "`n📋 Step 1: Install and Authenticate GitHub CLI" -ForegroundColor Green
Write-Host "GitHub CLI is already installed. Let's authenticate it." -ForegroundColor Yellow

# Add GitHub CLI to PATH for this session
$env:PATH += ";C:\Program Files\GitHub CLI"

Write-Host "`n🔐 Authenticating with GitHub..." -ForegroundColor Blue
Write-Host "This will open a browser window to authenticate with GitHub."
Write-Host "Please follow the authentication flow."

try {
    & "C:\Program Files\GitHub CLI\gh.exe" auth login --web
    Write-Host "✅ GitHub CLI authentication completed" -ForegroundColor Green
} catch {
    Write-Host "❌ Authentication failed. Please run manually: gh auth login --web" -ForegroundColor Red
    Write-Host "Press any key to continue with manual setup instructions..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

Write-Host "`n📋 Step 2: Create Repository Secrets" -ForegroundColor Green
Write-Host "Go to: https://github.com/vnyrjkmr/auth0-terraform-deployment/settings/secrets/actions" -ForegroundColor Yellow
Write-Host "Add these Repository Secrets:" -ForegroundColor Yellow
Write-Host "  • AUTH0_DOMAIN" -ForegroundColor Cyan
Write-Host "  • AUTH0_CLIENT_ID" -ForegroundColor Cyan
Write-Host "  • AUTH0_CLIENT_SECRET" -ForegroundColor Cyan

Write-Host "`n📋 Step 3: Create GitHub Environments" -ForegroundColor Green
Write-Host "Go to: https://github.com/vnyrjkmr/auth0-terraform-deployment/settings/environments" -ForegroundColor Yellow

Write-Host "`n🟢 Create 'dev' Environment:" -ForegroundColor Green
Write-Host "  1. Click 'New Environment'" -ForegroundColor White
Write-Host "  2. Name: dev" -ForegroundColor White
Write-Host "  3. Deployment branches: Add 'develop' and 'dev' patterns" -ForegroundColor White
Write-Host "  4. No required reviewers needed" -ForegroundColor White

Write-Host "`n🟡 Create 'qa' Environment:" -ForegroundColor Yellow
Write-Host "  1. Click 'New Environment'" -ForegroundColor White
Write-Host "  2. Name: qa" -ForegroundColor White
Write-Host "  3. Required reviewers: Add yourself and QA team members" -ForegroundColor White
Write-Host "  4. Wait timer: 5 minutes" -ForegroundColor White
Write-Host "  5. Deployment branches: Add 'qa', 'release/*', and 'main' patterns" -ForegroundColor White

Write-Host "`n🔴 Create 'prod' Environment:" -ForegroundColor Red
Write-Host "  1. Click 'New Environment'" -ForegroundColor White
Write-Host "  2. Name: prod" -ForegroundColor White
Write-Host "  3. Required reviewers: Add production approvers" -ForegroundColor White
Write-Host "  4. Wait timer: 10-15 minutes" -ForegroundColor White
Write-Host "  5. Deployment branches: Add 'main' pattern only" -ForegroundColor White

Write-Host "`n📋 Step 4: Automated Environment Creation (Alternative)" -ForegroundColor Green
Write-Host "If you prefer automation, run these commands:" -ForegroundColor Yellow

$commands = @(
    '& "C:\Program Files\GitHub CLI\gh.exe" api repos/vnyrjkmr/auth0-terraform-deployment/environments/dev -X PUT',
    '& "C:\Program Files\GitHub CLI\gh.exe" api repos/vnyrjkmr/auth0-terraform-deployment/environments/qa -X PUT',
    '& "C:\Program Files\GitHub CLI\gh.exe" api repos/vnyrjkmr/auth0-terraform-deployment/environments/prod -X PUT'
)

foreach ($cmd in $commands) {
    Write-Host "  $cmd" -ForegroundColor Cyan
}

Write-Host "`n📋 Step 5: Test the Setup" -ForegroundColor Green
Write-Host "1. Update qa.tfvars with your QA Auth0 credentials" -ForegroundColor White
Write-Host "2. Run validation: .\validate-github-setup.ps1" -ForegroundColor White
Write-Host "3. Test local deployment: .\deploy.ps1 dev" -ForegroundColor White
Write-Host "4. Test GitHub Actions by pushing to develop branch" -ForegroundColor White

Write-Host "`n✅ Setup Resources Created:" -ForegroundColor Green
Write-Host "📄 GitHub Actions Workflow: .github/workflows/deploy-auth0.yml" -ForegroundColor Cyan
Write-Host "📄 QA Configuration: qa.tfvars" -ForegroundColor Cyan
Write-Host "📄 Setup Documentation: GITHUB_DEPLOYMENT_SETUP.md" -ForegroundColor Cyan
Write-Host "📄 Validation Script: validate-github-setup.ps1" -ForegroundColor Cyan

Write-Host "`n🎯 Branch → Environment Mapping:" -ForegroundColor Green
Write-Host "  develop/dev → dev environment" -ForegroundColor Cyan
Write-Host "  qa/release/* → qa environment (with approval)" -ForegroundColor Cyan  
Write-Host "  main → prod environment (with approval)" -ForegroundColor Cyan

Write-Host "`n💡 Pro Tips:" -ForegroundColor Blue
Write-Host "• Use Pull Requests to review Terraform plans before deployment" -ForegroundColor White
Write-Host "• Check GitHub Actions logs if deployments fail" -ForegroundColor White
Write-Host "• Keep Auth0 credentials secure and rotate them regularly" -ForegroundColor White
Write-Host "• Test in dev environment before promoting to QA and prod" -ForegroundColor White

Write-Host "`n🔗 Useful Links:" -ForegroundColor Blue
Write-Host "Repository Secrets: https://github.com/vnyrjkmr/auth0-terraform-deployment/settings/secrets/actions" -ForegroundColor Cyan
Write-Host "Environments: https://github.com/vnyrjkmr/auth0-terraform-deployment/settings/environments" -ForegroundColor Cyan
Write-Host "Actions: https://github.com/vnyrjkmr/auth0-terraform-deployment/actions" -ForegroundColor Cyan
Write-Host "Auth0 Dashboard: https://manage.auth0.com/" -ForegroundColor Cyan