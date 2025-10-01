# 🎯 Demo Script 6: Monitoring & Verification
# Purpose: Real-time monitoring and verification of all deployment scenarios

Write-Host "🔥 DEMO 6: Monitoring & Verification Dashboard" -ForegroundColor Magenta
Write-Host "=" * 60 -ForegroundColor Cyan

# Functions for monitoring
function Show-WorkflowRuns {
    param([int]$Limit = 10)
    
    Write-Host "`n📊 Recent Workflow Runs:" -ForegroundColor Yellow
    Write-Host "=" * 50 -ForegroundColor Gray
    
    $runs = gh run list --limit $Limit --json displayTitle,status,conclusion,createdAt,headBranch,event,url | ConvertFrom-Json
    
    foreach ($run in $runs) {
        $status = if ($run.conclusion) { $run.conclusion } else { $run.status }
        $color = switch ($status) {
            "success" { "Green" }
            "failure" { "Red" }
            "in_progress" { "Yellow" }
            "queued" { "Cyan" }
            "cancelled" { "Gray" }
            default { "White" }
        }
        
        $icon = switch ($status) {
            "success" { "✅" }
            "failure" { "❌" }
            "in_progress" { "🔄" }
            "queued" { "⏳" }
            "cancelled" { "⏹️" }
            default { "❓" }
        }
        
        Write-Host "$icon [$status] $($run.displayTitle)" -ForegroundColor $color
        Write-Host "   📅 $($run.createdAt) | 🌿 $($run.headBranch) | ⚡ $($run.event)" -ForegroundColor Gray
        Write-Host "   🔗 $($run.url)" -ForegroundColor Blue
        Write-Host ""
    }
}

function Show-EnvironmentStatus {
    Write-Host "`n🌍 Environment Status Dashboard:" -ForegroundColor Cyan
    Write-Host "=" * 50 -ForegroundColor Gray
    
    # Development Environment
    Write-Host "`n🟡 DEVELOPMENT ENVIRONMENT" -ForegroundColor Yellow
    Write-Host "   🎯 Tenant: dev" -ForegroundColor Gray
    Write-Host "   📁 Config: config/dev.tfvars" -ForegroundColor Gray
    Write-Host "   🌿 Trigger: development branch, feature/* branches" -ForegroundColor Gray
    Write-Host "   📊 Status: [Check latest development deployment]" -ForegroundColor Gray
    
    # Staging Environment  
    Write-Host "`n🔵 STAGING ENVIRONMENT" -ForegroundColor Blue
    Write-Host "   🎯 Tenant: staging" -ForegroundColor Gray
    Write-Host "   📁 Config: config/qa.tfvars" -ForegroundColor Gray
    Write-Host "   🌿 Trigger: hotfix/* branches, release/* branches, v*.*-staging tags" -ForegroundColor Gray
    Write-Host "   📊 Status: [Check latest staging deployment]" -ForegroundColor Gray
    
    # Production Environment
    Write-Host "`n🔴 PRODUCTION ENVIRONMENT" -ForegroundColor Red
    Write-Host "   🎯 Tenant: prod" -ForegroundColor Gray
    Write-Host "   📁 Config: config/prod.tfvars" -ForegroundColor Gray  
    Write-Host "   🌿 Trigger: master/main branch, v*.* tags" -ForegroundColor Gray
    Write-Host "   📊 Status: [Check latest production deployment]" -ForegroundColor Gray
}

function Show-TagHistory {
    Write-Host "`n🏷️ Tag Deployment History:" -ForegroundColor Cyan
    Write-Host "=" * 50 -ForegroundColor Gray
    
    Write-Host "`n🔴 Production Tags:" -ForegroundColor Red
    git tag --list "v*" --sort=-version:refname | Where-Object { $_ -notlike "*staging*" -and $_ -notlike "*test*" } | Select-Object -First 5 | ForEach-Object {
        Write-Host "   📦 $_" -ForegroundColor Red
    }
    
    Write-Host "`n🔵 Staging Tags:" -ForegroundColor Blue  
    git tag --list "*staging*" --sort=-version:refname | Select-Object -First 5 | ForEach-Object {
        Write-Host "   📦 $_" -ForegroundColor Blue
    }
    
    Write-Host "`n🧪 Test/Demo Tags:" -ForegroundColor Gray
    git tag --list "*test*" --sort=-version:refname | Select-Object -First 5 | ForEach-Object {
        Write-Host "   📦 $_" -ForegroundColor Gray
    }
}

function Show-BranchStatus {
    Write-Host "`n🌿 Branch Status:" -ForegroundColor Cyan
    Write-Host "=" * 50 -ForegroundColor Gray
    
    $currentBranch = git branch --show-current
    Write-Host "`n📍 Current Branch: $currentBranch" -ForegroundColor Yellow
    
    Write-Host "`n🌿 Key Branches:" -ForegroundColor Green
    $branches = @("master", "main", "development")
    foreach ($branch in $branches) {
        $exists = git branch --list $branch
        if ($exists) {
            $lastCommit = git log $branch --oneline -1 2>$null
            if ($lastCommit) {
                Write-Host "   ✅ $branch - $lastCommit" -ForegroundColor Green
            } else {
                Write-Host "   ✅ $branch - [Available]" -ForegroundColor Green  
            }
        } else {
            Write-Host "   ❌ $branch - [Not found]" -ForegroundColor Red
        }
    }
    
    Write-Host "`n🔧 Active Feature/Hotfix Branches:" -ForegroundColor Cyan
    $activeBranches = git branch --list "feature/*", "hotfix/*", "release/*" 2>$null
    if ($activeBranches) {
        $activeBranches | ForEach-Object {
            $branchName = $_.Trim('* ')
            Write-Host "   🚧 $branchName" -ForegroundColor Cyan
        }
    } else {
        Write-Host "   📝 No active feature/hotfix branches" -ForegroundColor Gray
    }
}

function Watch-Deployment {
    param([string]$RunId)
    
    if (-not $RunId) {
        Write-Host "❌ Please provide a Run ID to watch" -ForegroundColor Red
        Write-Host "Usage: Watch-Deployment -RunId <run_id>" -ForegroundColor Gray
        return
    }
    
    Write-Host "`n👀 Watching Deployment: $RunId" -ForegroundColor Cyan
    Write-Host "=" * 50 -ForegroundColor Gray
    
    try {
        $runInfo = gh run view $RunId --json displayTitle,status,conclusion,jobs
        $run = $runInfo | ConvertFrom-Json
        
        Write-Host "`n📋 Deployment: $($run.displayTitle)" -ForegroundColor Yellow
        Write-Host "🔧 Status: $($run.status)" -ForegroundColor White
        
        if ($run.jobs) {
            Write-Host "`n📊 Jobs Status:" -ForegroundColor Cyan
            foreach ($job in $run.jobs) {
                $jobStatus = if ($job.conclusion) { $job.conclusion } else { $job.status }
                $color = switch ($jobStatus) {
                    "success" { "Green" }
                    "failure" { "Red" }
                    "in_progress" { "Yellow" }
                    default { "White" }
                }
                Write-Host "   $($job.name): $jobStatus" -ForegroundColor $color
            }
        }
        
        Write-Host "`n📝 Deployment Logs (last 10 relevant lines):" -ForegroundColor Cyan
        gh run view $RunId --log | Select-String -Pattern "(Environment|Tenant|Apply complete|Successfully deployed|ERROR|FAILED)" | Select-Object -Last 10
        
    } catch {
        Write-Host "❌ Error retrieving run information: $($_.Exception.Message)" -ForegroundColor Red
    }
}

function Show-DeploymentSummary {
    Write-Host "`n📈 Deployment Summary Dashboard:" -ForegroundColor Magenta
    Write-Host "=" * 60 -ForegroundColor Gray
    
    # Get recent runs and categorize them
    $runs = gh run list --limit 20 --json displayTitle,conclusion,headBranch,event,createdAt | ConvertFrom-Json
    
    $successful = ($runs | Where-Object { $_.conclusion -eq "success" }).Count
    $failed = ($runs | Where-Object { $_.conclusion -eq "failure" }).Count  
    $inProgress = ($runs | Where-Object { $_.conclusion -eq $null }).Count
    
    Write-Host "`n📊 Recent Deployment Stats:" -ForegroundColor Cyan
    Write-Host "   ✅ Successful: $successful" -ForegroundColor Green
    Write-Host "   ❌ Failed: $failed" -ForegroundColor Red
    Write-Host "   🔄 In Progress: $inProgress" -ForegroundColor Yellow
    
    # Deployment by trigger type
    $branchDeploys = ($runs | Where-Object { $_.event -eq "push" -and $_.headBranch -notlike "v*" }).Count
    $tagDeploys = ($runs | Where-Object { $_.event -eq "push" -and $_.headBranch -like "v*" }).Count
    $manualDeploys = ($runs | Where-Object { $_.event -eq "workflow_dispatch" }).Count
    
    Write-Host "`n🎯 Deployment Types:" -ForegroundColor Cyan
    Write-Host "   🌿 Branch-based: $branchDeploys" -ForegroundColor Green
    Write-Host "   🏷️ Tag-based: $tagDeploys" -ForegroundColor Blue
    Write-Host "   🔧 Manual: $manualDeploys" -ForegroundColor Yellow
    
    # Environment deployments (approximation based on branch/tag patterns)
    $prodDeploys = ($runs | Where-Object { 
        ($_.headBranch -eq "master" -or $_.headBranch -eq "main") -or
        ($_.headBranch -like "v*" -and $_.headBranch -notlike "*staging*")
    }).Count
    
    $stagingDeploys = ($runs | Where-Object {
        $_.headBranch -like "hotfix/*" -or $_.headBranch -like "release/*" -or $_.headBranch -like "*staging*"
    }).Count
    
    $devDeploys = ($runs | Where-Object {
        $_.headBranch -eq "development" -or $_.headBranch -like "feature/*"
    }).Count
    
    Write-Host "`n🌍 Environment Deployments:" -ForegroundColor Cyan
    Write-Host "   🔴 Production: $prodDeploys" -ForegroundColor Red
    Write-Host "   🔵 Staging: $stagingDeploys" -ForegroundColor Blue
    Write-Host "   🟡 Development: $devDeploys" -ForegroundColor Yellow
}

# Main monitoring execution
Write-Host "`n🎯 Starting Comprehensive Monitoring Session..." -ForegroundColor Magenta

# Step 1: Show current workflow status
Show-WorkflowRuns -Limit 8

# Step 2: Show environment status
Show-EnvironmentStatus

# Step 3: Show tag history
Show-TagHistory

# Step 4: Show branch status
Show-BranchStatus

# Step 5: Show deployment summary
Show-DeploymentSummary

# Interactive monitoring commands
Write-Host "`n🛠️ Interactive Monitoring Commands:" -ForegroundColor Cyan
Write-Host "=" * 50 -ForegroundColor Gray

Write-Host "`n📊 Real-time Commands:" -ForegroundColor Yellow
Write-Host "# Watch latest run" -ForegroundColor Gray
Write-Host 'Show-WorkflowRuns -Limit 3' -ForegroundColor Gray

Write-Host "`n# Monitor specific deployment" -ForegroundColor Gray  
Write-Host 'gh run list --limit 1 --json id | ConvertFrom-Json | ForEach-Object { Watch-Deployment -RunId $_.id }' -ForegroundColor Gray

Write-Host "`n# Get deployment details" -ForegroundColor Gray
Write-Host 'gh run view [RUN_ID] --log | Select-String -Pattern "(Environment|Tenant|Apply complete)" | Select-Object -Last 15' -ForegroundColor Gray

Write-Host "`n# Check specific environment deployments" -ForegroundColor Gray
Write-Host 'gh run list --json displayTitle,headBranch,conclusion | ConvertFrom-Json | Where-Object { $_.headBranch -eq "development" }' -ForegroundColor Gray

Write-Host "`n🔍 Verification Commands:" -ForegroundColor Yellow
Write-Host "# Verify tag deployments" -ForegroundColor Gray
Write-Host 'git tag --sort=-version:refname | Select-Object -First 10' -ForegroundColor Gray

Write-Host "`n# Check environment configurations" -ForegroundColor Gray  
Write-Host 'Get-Content config/*.tfvars | Select-String "environment|tenant"' -ForegroundColor Gray

Write-Host "`n# Monitor active workflows" -ForegroundColor Gray
Write-Host 'gh run list --status in_progress' -ForegroundColor Gray

# Quick status check
Write-Host "`n⚡ Quick Status Check:" -ForegroundColor Magenta
$latestRun = gh run list --limit 1 --json id,displayTitle,status,conclusion | ConvertFrom-Json
if ($latestRun) {
    $status = if ($latestRun.conclusion) { $latestRun.conclusion } else { $latestRun.status }
    $color = switch ($status) {
        "success" { "Green" }
        "failure" { "Red" }
        "in_progress" { "Yellow" }
        default { "White" }
    }
    Write-Host "Latest Deployment: $($latestRun.displayTitle) - $status" -ForegroundColor $color
    
    if ($status -eq "in_progress") {
        Write-Host "🔄 Deployment in progress - use Watch-Deployment to monitor" -ForegroundColor Yellow
    }
}

Write-Host "`n💡 Pro Tips:" -ForegroundColor Cyan
Write-Host "• Use 'gh run list --branch [branch-name]' to filter by branch" -ForegroundColor Gray
Write-Host "• Check 'https://github.com/vnyrjkmr/auth0-terraform-deployment/actions' for full UI" -ForegroundColor Gray
Write-Host "• Look for 'Apply complete!' message to confirm successful deployments" -ForegroundColor Gray
Write-Host "• Monitor Auth0 dashboard for actual tenant changes" -ForegroundColor Gray

Write-Host "`n" + "=" * 60 -ForegroundColor Cyan
Write-Host "Monitoring Dashboard Ready!" -ForegroundColor Green
Write-Host "Use the commands above to monitor deployments in real-time." -ForegroundColor White