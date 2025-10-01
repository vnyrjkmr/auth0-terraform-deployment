# Validate GitHub Actions Workflow Configuration
# This script checks if your GitHub Actions workflow is properly configured

param(
    [switch]$CheckSecrets = $false,
    [string]$Environment = "dev"
)

$Green = [System.ConsoleColor]::Green
$Yellow = [System.ConsoleColor]::Yellow  
$Red = [System.ConsoleColor]::Red
$Blue = [System.ConsoleColor]::Blue

function Write-ColorOutput {
    param([string]$Message, [System.ConsoleColor]$Color = [System.ConsoleColor]::White)
    Write-Host $Message -ForegroundColor $Color
}

function Test-FileExists {
    param([string]$FilePath, [string]$Description)
    
    if (Test-Path $FilePath) {
        Write-ColorOutput "✅ $Description found: $FilePath" $Green
        return $true
    } else {
        Write-ColorOutput "❌ $Description missing: $FilePath" $Red
        return $false
    }
}

function Test-WorkflowFile {
    $workflowPath = ".github/workflows/deploy-auth0.yml"
    
    if (-not (Test-FileExists $workflowPath "GitHub Actions workflow")) {
        return $false
    }
    
    $workflowContent = Get-Content $workflowPath -Raw
    
    # Check for required workflow components
    $requiredComponents = @(
        "determine-environment",
        "terraform-plan", 
        "terraform-apply",
        "AUTH0_DOMAIN",
        "AUTH0_CLIENT_ID",
        "AUTH0_CLIENT_SECRET"
    )
    
    $missing = @()
    foreach ($component in $requiredComponents) {
        if ($workflowContent -notmatch $component) {
            $missing += $component
        }
    }
    
    if ($missing.Count -eq 0) {
        Write-ColorOutput "✅ Workflow file contains all required components" $Green
        return $true
    } else {
        Write-ColorOutput "❌ Workflow file missing components: $($missing -join ', ')" $Red
        return $false
    }
}

function Test-TerraformFiles {
    $requiredFiles = @{
        "main.tf" = "Terraform main configuration"
        "variables.tf" = "Terraform variables"
        "terraform.tfvars" = "Terraform base variables (should contain Auth0 credentials)"
        "dev.tfvars" = "Development environment variables"
        "qa.tfvars" = "QA environment variables"
        "prod.tfvars" = "Production environment variables"
    }
    
    $allFound = $true
    foreach ($file in $requiredFiles.GetEnumerator()) {
        if (-not (Test-FileExists $file.Key $file.Value)) {
            $allFound = $false
        }
    }
    
    return $allFound
}

function Test-EnvironmentFiles {
    param([string]$Env)
    
    $envFile = "${Env}.tfvars"
    if (-not (Test-Path $envFile)) {
        Write-ColorOutput "❌ Environment file missing: $envFile" $Red
        return $false
    }
    
    $content = Get-Content $envFile -Raw
    $requiredVars = @("auth0_domain", "project_name")
    
    $missing = @()
    foreach ($var in $requiredVars) {
        if ($content -notmatch $var) {
            $missing += $var
        }
    }
    
    if ($missing.Count -eq 0) {
        Write-ColorOutput "✅ Environment file $envFile contains required variables" $Green
        return $true
    } else {
        Write-ColorOutput "❌ Environment file $envFile missing variables: $($missing -join ', ')" $Red
        return $false
    }
}

function Show-NextSteps {
    Write-ColorOutput "`n📋 Next Steps to Complete Setup:" $Blue
    Write-ColorOutput "1. 🔐 Set up GitHub Repository Secrets:" $Blue
    Write-ColorOutput "   - Go to: https://github.com/[YOUR_USERNAME]/[YOUR_REPO]/settings/secrets/actions" $Blue
    Write-ColorOutput "   - Add: AUTH0_DOMAIN, AUTH0_CLIENT_ID, AUTH0_CLIENT_SECRET" $Blue
    
    Write-ColorOutput "`n2. 🌍 Create GitHub Environments:" $Blue
    Write-ColorOutput "   - Run: ./setup-github-environments.ps1" $Blue
    Write-ColorOutput "   - Or manually create 'dev', 'qa', and 'prod' environments in GitHub" $Blue
    
    Write-ColorOutput "`n3. 🔧 Configure Branch Protection:" $Blue
    Write-ColorOutput "   - Protect 'main' branch to require PR reviews" $Blue
    Write-ColorOutput "   - Set 'prod' environment to require approval" $Blue
    
    Write-ColorOutput "`n4. 🚀 Test Deployment:" $Blue
    Write-ColorOutput "   - Create a feature branch and push to 'develop' → deploys to dev" $Blue
    Write-ColorOutput "   - Create PR from 'develop' to 'qa' → deploys to qa (with approval)" $Blue
    Write-ColorOutput "   - Create PR from 'qa' to 'main' → deploys to prod (with approval)" $Blue
    Write-ColorOutput "   - Verify workflows run and show Terraform plans" $Blue
    
    Write-ColorOutput "`n5. 📚 Review Documentation:" $Blue
    Write-ColorOutput "   - Read GITHUB_DEPLOYMENT_SETUP.md for detailed instructions" $Blue
}

# Main validation
Write-ColorOutput "🔍 Validating GitHub Actions Deployment Setup" $Blue
Write-ColorOutput "Environment: $Environment" $Blue

$validationResults = @{
    "Workflow File" = Test-WorkflowFile
    "Terraform Files" = Test-TerraformFiles  
    "Environment Files" = Test-EnvironmentFiles -Env $Environment
}

Write-ColorOutput "`n📊 Validation Results:" $Blue
$allPassed = $true
foreach ($result in $validationResults.GetEnumerator()) {
    $status = if ($result.Value) { "✅ PASS" } else { "❌ FAIL"; $allPassed = $false }
    Write-ColorOutput "   $($result.Key): $status" $(if ($result.Value) { $Green } else { $Red })
}

if ($allPassed) {
    Write-ColorOutput "`n🎉 All validation checks passed!" $Green
    Write-ColorOutput "Your GitHub Actions deployment is ready to use." $Green
} else {
    Write-ColorOutput "`n⚠️ Some validation checks failed." $Yellow
    Write-ColorOutput "Please address the issues above before proceeding." $Yellow
}

Show-NextSteps

Write-ColorOutput "`n💡 Pro Tips:" $Blue
Write-ColorOutput "• Test locally first: ./deploy.ps1 dev" $Blue
Write-ColorOutput "• Use Pull Requests to review changes before deployment" $Blue  
Write-ColorOutput "• Monitor workflow runs in the GitHub Actions tab" $Blue
Write-ColorOutput "• Keep Auth0 credentials secure and rotate them regularly" $Blue