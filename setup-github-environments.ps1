# GitHub Environment Configuration Script
# This script helps you set up GitHub Environments via GitHub CLI

# Prerequisites:
# 1. Install GitHub CLI: https://cli.github.com/
# 2. Authenticate: gh auth login
# 3. Navigate to your repository directory

param(
    [string]$RepoOwner = "vnyrjkmr",  # Update with your GitHub username/org
    [string]$RepoName = "auth0-terraform-deployment",  # Update with your repo name
    [switch]$DryRun = $false
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

function Test-GitHubCli {
    # Try to find GitHub CLI in common locations
    $ghPaths = @(
        "gh",  # If in PATH
        "C:\Program Files\GitHub CLI\gh.exe",
        "${env:LOCALAPPDATA}\GitHubCLI\gh.exe"
    )
    
    foreach ($ghPath in $ghPaths) {
        try {
            $ghVersion = & $ghPath --version 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-ColorOutput "✅ GitHub CLI found: $($ghVersion[0]) at $ghPath" $Green
                $script:GhPath = $ghPath
                return $true
            }
        } catch {
            continue
        }
    }
    
    Write-ColorOutput "❌ GitHub CLI not found. Please install from: https://cli.github.com/" $Red
    Write-ColorOutput "   Or run the manual setup: .\setup-manual.ps1" $Yellow
    return $false
}

function Test-Authentication {
    try {
        & $script:GhPath auth status 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "✅ GitHub CLI authenticated successfully" $Green
            return $true
        } else {
            Write-ColorOutput "❌ GitHub CLI not authenticated. Run: & `"$($script:GhPath)`" auth login" $Red
            return $false
        }
    } catch {
        Write-ColorOutput "❌ Failed to check GitHub CLI authentication" $Red
        return $false
    }
}

function New-GitHubEnvironment {
    param(
        [string]$EnvironmentName,
        [string[]]$Reviewers = @(),
        [int]$WaitTimer = 0,
        [string[]]$DeploymentBranches = @()
    )
    
    Write-ColorOutput "🏗️ Creating environment: $EnvironmentName" $Blue
    
    if ($DryRun) {
        Write-ColorOutput "[DRY RUN] Would create environment: $EnvironmentName" $Yellow
        return
    }
    
    try {
        # Create the environment
        & $script:GhPath api repos/$RepoOwner/$RepoName/environments/$EnvironmentName -X PUT
        Write-ColorOutput "✅ Environment '$EnvironmentName' created successfully" $Green
        
        # Configure protection rules if specified
        if ($Reviewers.Count -gt 0 -or $WaitTimer -gt 0 -or $DeploymentBranches.Count -gt 0) {
            $protectionRules = @{}
            
            if ($Reviewers.Count -gt 0) {
                $protectionRules.reviewers = @(
                    $Reviewers | ForEach-Object {
                        @{
                            type = "User"
                            id = (& $script:GhPath api users/$_ | ConvertFrom-Json).id
                        }
                    }
                )
            }
            
            if ($WaitTimer -gt 0) {
                $protectionRules.wait_timer = $WaitTimer
            }
            
            if ($DeploymentBranches.Count -gt 0) {
                $protectionRules.deployment_branch_policy = @{
                    protected_branches = $false
                    custom_branch_policies = $true
                }
            }
            
            $protectionJson = $protectionRules | ConvertTo-Json -Depth 10
            $protectionJson | & $script:GhPath api repos/$RepoOwner/$RepoName/environments/$EnvironmentName -X PUT --input -
            
            # Add deployment branch policies
            if ($DeploymentBranches.Count -gt 0) {
                foreach ($branch in $DeploymentBranches) {
                    $branchPolicy = @{
                        name = $branch
                        type = "branch"
                    } | ConvertTo-Json
                    
                    $branchPolicy | & $script:GhPath api repos/$RepoOwner/$RepoName/environments/$EnvironmentName/deployment-branch-policies -X POST --input -
                }
            }
        }
        
    } catch {
        Write-ColorOutput "❌ Failed to create environment '$EnvironmentName': $($_.Exception.Message)" $Red
    }
}

function Set-RepositorySecret {
    param(
        [string]$SecretName,
        [string]$SecretValue,
        [string]$EnvironmentName = $null
    )
    
    if ($DryRun) {
        $scope = if ($EnvironmentName) { "environment '$EnvironmentName'" } else { "repository" }
        Write-ColorOutput "[DRY RUN] Would set secret '$SecretName' for $scope" $Yellow
        return
    }
    
    try {
        if ($EnvironmentName) {
            # Set environment secret
            Write-ColorOutput "🔐 Setting environment secret: $SecretName for $EnvironmentName" $Blue
            $secretValue = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($SecretValue))
            gh secret set $SecretName --body $SecretValue --env $EnvironmentName
        } else {
            # Set repository secret  
            Write-ColorOutput "🔐 Setting repository secret: $SecretName" $Blue
            gh secret set $SecretName --body $SecretValue
        }
        Write-ColorOutput "✅ Secret '$SecretName' set successfully" $Green
    } catch {
        Write-ColorOutput "❌ Failed to set secret '$SecretName': $($_.Exception.Message)" $Red
    }
}

# Main execution
Write-ColorOutput "🚀 GitHub Environment Setup for Auth0 Terraform Deployment" $Blue
Write-ColorOutput "Repository: $RepoOwner/$RepoName" $Blue

if ($DryRun) {
    Write-ColorOutput "🧪 DRY RUN MODE - No actual changes will be made" $Yellow
}

# Prerequisites check
if (-not (Test-GitHubCli)) { exit 1 }
if (-not (Test-Authentication)) { exit 1 }

Write-ColorOutput "`n📋 Setting up environments..." $Blue

# Create Development Environment
New-GitHubEnvironment -EnvironmentName "dev" -DeploymentBranches @("develop", "dev")

# Create QA Environment with moderate protection
$qaReviewers = @("vnyrjkmr")  # Update with actual QA team GitHub usernames
New-GitHubEnvironment -EnvironmentName "qa" -Reviewers $qaReviewers -WaitTimer 300 -DeploymentBranches @("qa", "release/*", "main")

# Create Production Environment with strict protection rules
$prodReviewers = @("vnyrjkmr")  # Update with actual production approvers GitHub usernames
New-GitHubEnvironment -EnvironmentName "prod" -Reviewers $prodReviewers -WaitTimer 600 -DeploymentBranches @("main")

Write-ColorOutput "`n🔐 Repository secrets setup..." $Blue
Write-ColorOutput "⚠️  You need to manually set the following secrets in GitHub UI:" $Yellow
Write-ColorOutput "   1. Go to: https://github.com/$RepoOwner/$RepoName/settings/secrets/actions" $Yellow
Write-ColorOutput "   2. Add these Repository Secrets:" $Yellow
Write-ColorOutput "      - AUTH0_DOMAIN (e.g., dev-example.us.auth0.com)" $Yellow  
Write-ColorOutput "      - AUTH0_CLIENT_ID (Management API Client ID)" $Yellow
Write-ColorOutput "      - AUTH0_CLIENT_SECRET (Management API Client Secret)" $Yellow

# Optionally set secrets via CLI (requires manual input for security)
$setSecrets = Read-Host "`nDo you want to set Auth0 secrets now? (y/N)"
if ($setSecrets -eq 'y' -or $setSecrets -eq 'Y') {
    $auth0Domain = Read-Host "Enter AUTH0_DOMAIN (e.g., dev-example.us.auth0.com)"
    $auth0ClientId = Read-Host "Enter AUTH0_CLIENT_ID"
    $auth0ClientSecret = Read-Host "Enter AUTH0_CLIENT_SECRET" -AsSecureString
    $auth0ClientSecretPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($auth0ClientSecret))
    
    Set-RepositorySecret -SecretName "AUTH0_DOMAIN" -SecretValue $auth0Domain
    Set-RepositorySecret -SecretName "AUTH0_CLIENT_ID" -SecretValue $auth0ClientId  
    Set-RepositorySecret -SecretName "AUTH0_CLIENT_SECRET" -SecretValue $auth0ClientSecretPlain
}

Write-ColorOutput "`n✅ GitHub Environment setup completed!" $Green
Write-ColorOutput "📚 Next steps:" $Blue
Write-ColorOutput "   1. Review the created environments at: https://github.com/$RepoOwner/$RepoName/settings/environments" $Blue
Write-ColorOutput "   2. Add team members as reviewers for the 'qa' and 'prod' environments" $Blue
Write-ColorOutput "   3. Set up the required repository secrets (or environment-specific secrets)" $Blue
Write-ColorOutput "   4. Update qa.tfvars with your actual QA Auth0 domain and credentials" $Blue
Write-ColorOutput "   5. Test the deployment by pushing to the 'develop' branch" $Blue
Write-ColorOutput "   6. Review GITHUB_DEPLOYMENT_SETUP.md for detailed instructions" $Blue