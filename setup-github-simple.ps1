# GitHub CLI Setup with PATH Management
# This script automatically handles GitHub CLI PATH issues

param(
    [string]$RepoOwner = "vnyrjkmr",
    [string]$RepoName = "auth0-terraform-deployment",
    [switch]$AuthenticateOnly = $false
)

# Colors for output
$Green = [System.ConsoleColor]::Green
$Yellow = [System.ConsoleColor]::Yellow
$Red = [System.ConsoleColor]::Red
$Blue = [System.ConsoleColor]::Blue

function Write-ColorOutput {
    param([string]$Message, [System.ConsoleColor]$Color = [System.ConsoleColor]::White)
    Write-Host $Message -ForegroundColor $Color
}

# Find and set GitHub CLI path
$ghPath = $null
$possiblePaths = @(
    "C:\Program Files\GitHub CLI\gh.exe",
    "${env:LOCALAPPDATA}\GitHubCLI\gh.exe",
    "gh"  # If already in PATH
)

foreach ($path in $possiblePaths) {
    try {
        $version = & $path --version 2>$null
        if ($LASTEXITCODE -eq 0) {
            $ghPath = $path
            Write-ColorOutput "✅ Found GitHub CLI at: $ghPath" $Green
            Write-ColorOutput "   Version: $($version[0])" $Blue
            break
        }
    } catch {
        continue
    }
}

if (-not $ghPath) {
    Write-ColorOutput "❌ GitHub CLI not found!" $Red
    Write-ColorOutput "Please install GitHub CLI from: https://cli.github.com/" $Yellow
    exit 1
}

# Add GitHub CLI directory to PATH for this session if needed
if ($ghPath -like "*Program Files*") {
    $ghDir = Split-Path -Parent $ghPath
    if ($env:PATH -notlike "*$ghDir*") {
        $env:PATH += ";$ghDir"
        Write-ColorOutput "✅ Added GitHub CLI to PATH for this session" $Green
    }
}

Write-ColorOutput "`n🔐 Checking GitHub CLI authentication..." $Blue

# Test authentication
try {
    & $ghPath auth status 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "✅ GitHub CLI is already authenticated" $Green
        
        # Show current user
        $currentUser = & $ghPath api user --jq .login 2>$null
        if ($currentUser) {
            Write-ColorOutput "   Logged in as: $currentUser" $Blue
        }
        
        if ($AuthenticateOnly) {
            Write-ColorOutput "`n✅ Authentication check completed!" $Green
            exit 0
        }
    } else {
        Write-ColorOutput "❌ GitHub CLI not authenticated" $Red
        Write-ColorOutput "`n🚀 Starting authentication process..." $Blue
        Write-ColorOutput "This will open your web browser for authentication." $Yellow
        Write-ColorOutput "Press any key to continue..." $Yellow
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        
        # Authenticate
        & $ghPath auth login --web --git-protocol https
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "✅ Authentication successful!" $Green
        } else {
            Write-ColorOutput "❌ Authentication failed" $Red
            Write-ColorOutput "Please try again or check your internet connection" $Yellow
            exit 1
        }
        
        if ($AuthenticateOnly) {
            Write-ColorOutput "`n✅ Authentication completed!" $Green
            exit 0
        }
    }
} catch {
    Write-ColorOutput "❌ Failed to check authentication: $($_.Exception.Message)" $Red
    exit 1
}

# If not authentication-only, proceed with environment setup
Write-ColorOutput "`n🏗️ Setting up GitHub Environments..." $Blue

# Simple environment creation using GitHub CLI
$environments = @("dev", "qa", "prod")

foreach ($env in $environments) {
    Write-ColorOutput "Creating environment: $env" $Blue
    
    try {
        & $ghPath api repos/$RepoOwner/$RepoName/environments/$env -X PUT
        Write-ColorOutput "✅ Environment '$env' created successfully" $Green
    } catch {
        Write-ColorOutput "❌ Failed to create environment '$env': $($_.Exception.Message)" $Red
    }
}

Write-ColorOutput "`n📋 Manual Configuration Required:" $Yellow
Write-ColorOutput "`n🔐 Repository Secrets (Required):" $Blue
Write-ColorOutput "Go to: https://github.com/$RepoOwner/$RepoName/settings/secrets/actions" $Cyan
Write-ColorOutput "Add these secrets:" $Blue
Write-ColorOutput "  • AUTH0_DOMAIN" $Cyan
Write-ColorOutput "  • AUTH0_CLIENT_ID" $Cyan  
Write-ColorOutput "  • AUTH0_CLIENT_SECRET" $Cyan

Write-ColorOutput "`n🛡️ Environment Protection Rules:" $Blue
Write-ColorOutput "Go to: https://github.com/$RepoOwner/$RepoName/settings/environments" $Cyan

Write-ColorOutput "`nFor 'qa' environment:" $Yellow
Write-ColorOutput "  • Add required reviewers" $White
Write-ColorOutput "  • Set wait timer: 5 minutes" $White
Write-ColorOutput "  • Deployment branches: qa, release/*, main" $White

Write-ColorOutput "`nFor 'prod' environment:" $Red
Write-ColorOutput "  • Add required reviewers" $White
Write-ColorOutput "  • Set wait timer: 10-15 minutes" $White
Write-ColorOutput "  • Deployment branches: main only" $White

Write-ColorOutput "`n📚 Next Steps:" $Green
Write-ColorOutput "1. Configure the secrets and environment protection rules above" $White
Write-ColorOutput "2. Update qa.tfvars with your QA Auth0 credentials" $White
Write-ColorOutput "3. Test deployment: .\deploy.ps1 dev" $White
Write-ColorOutput "4. Validate setup: .\validate-github-setup.ps1" $White

Write-ColorOutput "`n✅ GitHub Environments setup completed!" $Green
Write-ColorOutput "Check your repository settings to complete the configuration." $Blue