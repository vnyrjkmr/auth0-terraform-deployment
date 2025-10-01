# 🎯 Demo Script 7: Cleanup & Reset  
# Purpose: Clean up demo artifacts and reset environment for next demo

Write-Host "🔥 DEMO 7: Cleanup & Reset Environment" -ForegroundColor Magenta
Write-Host "=" * 60 -ForegroundColor Cyan

Write-Host "`n🧹 Starting Demo Cleanup Process..." -ForegroundColor Yellow

# Function to safely clean demo files
function Remove-DemoFiles {
    Write-Host "`n📍 Step 1: Removing demo artifacts" -ForegroundColor Yellow
    
    $patterns = @(
        "*DEMO*",
        "*TEST*", 
        "*HOTFIX*",
        "*FEATURE*",
        "*PRODUCTION-RELEASE*",
        "*STAGING-RELEASE*",
        "*DEV-DEPLOYMENT*",
        "*CRITICAL-HOTFIX*"
    )
    
    $removedFiles = @()
    foreach ($pattern in $patterns) {
        $files = Get-ChildItem -Path . -Filter $pattern -File 2>$null
        if ($files) {
            foreach ($file in $files) {
                Write-Host "   🗑️ Removing: $($file.Name)" -ForegroundColor Gray
                Remove-Item $file.FullName -Force
                $removedFiles += $file.Name
            }
        }
    }
    
    if ($removedFiles.Count -gt 0) {
        Write-Host "✅ Removed $($removedFiles.Count) demo files" -ForegroundColor Green
    } else {
        Write-Host "✅ No demo files found to remove" -ForegroundColor Green
    }
}

# Function to clean up demo branches
function Remove-DemoBranches {
    param([switch]$Force)
    
    Write-Host "`n📍 Step 2: Cleaning up demo branches" -ForegroundColor Yellow
    
    if (-not $Force) {
        Write-Host "⚠️  Demo branch cleanup requires confirmation" -ForegroundColor Red
        $confirm = Read-Host "Remove demo branches? (y/N)"
        if ($confirm -ne 'y' -and $confirm -ne 'Y') {
            Write-Host "❌ Branch cleanup cancelled" -ForegroundColor Yellow
            return
        }
    }
    
    # Switch to safe branch first
    Write-Host "   📍 Switching to development branch" -ForegroundColor Gray
    git checkout development 2>$null
    
    # Remove local demo branches
    $demoBranches = @()
    $patterns = @("feature/*demo*", "hotfix/*demo*", "release/*demo*", "feature/*team-demo*", "hotfix/*critical*", "hotfix/*security*")
    
    foreach ($pattern in $patterns) {
        $branches = git branch --list $pattern 2>$null
        if ($branches) {
            $demoBranches += $branches
        }
    }
    
    if ($demoBranches.Count -gt 0) {
        Write-Host "   🌿 Found $($demoBranches.Count) demo branches to remove" -ForegroundColor Cyan
        foreach ($branch in $demoBranches) {
            $branchName = $branch.Trim('* ')
            Write-Host "   🗑️ Deleting: $branchName" -ForegroundColor Gray
            git branch -D $branchName 2>$null
            
            # Try to remove from remote (if exists)
            git push origin --delete $branchName 2>$null
        }
        Write-Host "✅ Demo branches cleaned up" -ForegroundColor Green
    } else {
        Write-Host "✅ No demo branches found" -ForegroundColor Green
    }
}

# Function to clean up demo tags
function Remove-DemoTags {
    param([switch]$Force)
    
    Write-Host "`n📍 Step 3: Cleaning up demo tags" -ForegroundColor Yellow
    
    if (-not $Force) {
        Write-Host "⚠️  Demo tag cleanup requires confirmation" -ForegroundColor Red
        $confirm = Read-Host "Remove demo/test tags? (y/N)"
        if ($confirm -ne 'y' -and $confirm -ne 'Y') {
            Write-Host "❌ Tag cleanup cancelled" -ForegroundColor Yellow
            return
        }
    }
    
    # Find demo tags
    $demoTagPatterns = @("*test*", "*demo*", "*staging*")
    $demoTags = @()
    
    foreach ($pattern in $demoTagPatterns) {
        $tags = git tag --list $pattern 2>$null
        if ($tags) {
            $demoTags += $tags
        }
    }
    
    if ($demoTags.Count -gt 0) {
        Write-Host "   🏷️ Found $($demoTags.Count) demo tags to remove" -ForegroundColor Cyan
        foreach ($tag in $demoTags) {
            Write-Host "   🗑️ Deleting tag: $tag" -ForegroundColor Gray
            git tag -d $tag 2>$null
            git push origin --delete $tag 2>$null
        }
        Write-Host "✅ Demo tags cleaned up" -ForegroundColor Green
    } else {
        Write-Host "✅ No demo tags found" -ForegroundColor Green
    }
}

# Function to show cleanup summary
function Show-CleanupSummary {
    Write-Host "`n📊 Cleanup Summary:" -ForegroundColor Cyan
    Write-Host "=" * 40 -ForegroundColor Gray
    
    # Check current state
    $currentBranch = git branch --show-current
    Write-Host "📍 Current Branch: $currentBranch" -ForegroundColor Yellow
    
    # Check for remaining artifacts
    $remainingFiles = Get-ChildItem -Path . -Filter "*DEMO*", "*TEST*" -File 2>$null
    if ($remainingFiles) {
        Write-Host "⚠️  Remaining demo files: $($remainingFiles.Count)" -ForegroundColor Yellow
    } else {
        Write-Host "✅ No demo files remaining" -ForegroundColor Green
    }
    
    # Check branches
    $activeBranches = git branch --list "feature/*", "hotfix/*" 2>$null
    if ($activeBranches) {
        Write-Host "🌿 Active branches: $($activeBranches.Count)" -ForegroundColor Cyan
        $activeBranches | ForEach-Object {
            Write-Host "   • $($_.Trim('* '))" -ForegroundColor Gray
        }
    } else {
        Write-Host "✅ No active feature/hotfix branches" -ForegroundColor Green
    }
    
    # Check tags
    $allTags = git tag --list 2>$null
    if ($allTags) {
        $prodTags = $allTags | Where-Object { $_ -like "v*" -and $_ -notlike "*test*" -and $_ -notlike "*staging*" }
        $demoTags = $allTags | Where-Object { $_ -like "*test*" -or $_ -like "*demo*" -or $_ -like "*staging*" }
        
        Write-Host "🏷️ Production tags: $($prodTags.Count)" -ForegroundColor Green
        Write-Host "🏷️ Demo/test tags: $($demoTags.Count)" -ForegroundColor Yellow
    }
}

# Function to reset to clean state
function Reset-ToCleanState {
    Write-Host "`n📍 Step 4: Resetting to clean state" -ForegroundColor Yellow
    
    # Ensure we're on development branch
    git checkout development
    git pull origin development
    
    # Refresh branch state
    git fetch --all --prune
    
    Write-Host "✅ Repository reset to clean development state" -ForegroundColor Green
}

# Function to prepare for next demo
function Prepare-NextDemo {
    Write-Host "`n📍 Step 5: Preparing for next demo" -ForegroundColor Yellow
    
    # Create a fresh demo preparation file
    $prepContent = @"
# Demo Environment Ready - $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

## 🎯 Demo Environment Status: READY

### Repository State
- Current Branch: $(git branch --show-current)
- Repository: Clean and ready
- Demo artifacts: Removed
- Branches: Reset to standard branches

### Available Demo Scripts
- demo-1-development.ps1    → Development branch deployment
- demo-2-feature.ps1        → Feature branch workflow  
- demo-3-production-tag.ps1 → Production tag deployment
- demo-4-staging-tag.ps1    → Staging tag deployment
- demo-5-hotfix.ps1         → Emergency hotfix flow
- demo-6-monitoring.ps1     → Monitoring and verification
- demo-7-cleanup.ps1        → Cleanup and reset

### Environment Configuration
- Development: config/dev.tfvars   → dev tenant
- Staging:     config/qa.tfvars    → staging tenant  
- Production:  config/prod.tfvars  → prod tenant

### Pre-Demo Checklist
- [ ] Verify GitHub Actions access
- [ ] Confirm Auth0 tenant access
- [ ] Test deployment pipeline
- [ ] Prepare monitoring dashboard
- [ ] Brief team on demo flow

---
**Environment Ready**: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')  
**Next Demo**: Ready to execute  
**Duration**: ~35 minutes for full demo cycle
"@

    $prepContent | Out-File -FilePath "DEMO-ENVIRONMENT-READY.md" -Encoding UTF8
    Write-Host "✅ Demo preparation complete" -ForegroundColor Green
    Write-Host "📋 Created: DEMO-ENVIRONMENT-READY.md" -ForegroundColor Cyan
}

# Main cleanup execution
Write-Host "`n🎯 Executing Cleanup Sequence..." -ForegroundColor Magenta

# Execute cleanup steps
Remove-DemoFiles

# Ask for branch cleanup
Remove-DemoBranches

# Ask for tag cleanup  
Remove-DemoTags

# Reset to clean state
Reset-ToCleanState

# Show cleanup results
Show-CleanupSummary

# Prepare for next demo
Prepare-NextDemo

# Final status
Write-Host "`n🎯 Cleanup Complete!" -ForegroundColor Green
Write-Host "=" * 60 -ForegroundColor Cyan

Write-Host "`n✅ Environment Status:" -ForegroundColor Yellow
Write-Host "   📁 Demo files: Cleaned" -ForegroundColor Green
Write-Host "   🌿 Branches: Reset" -ForegroundColor Green  
Write-Host "   🏷️ Tags: Cleaned (optional)" -ForegroundColor Green
Write-Host "   📍 Current: development branch" -ForegroundColor Green
Write-Host "   🎯 Status: Ready for next demo" -ForegroundColor Green

Write-Host "`n🚀 Ready for Next Demo!" -ForegroundColor Magenta
Write-Host "Execute scripts in order: demo-1 through demo-6" -ForegroundColor White
Write-Host "Full demo cycle: ~35 minutes" -ForegroundColor Gray
Write-Host "Monitor: https://github.com/vnyrjkmr/auth0-terraform-deployment/actions" -ForegroundColor Blue

Write-Host "`n💡 Next Demo Commands:" -ForegroundColor Cyan
Write-Host ".\scripts\demo-1-development.ps1     # Start with development deployment" -ForegroundColor Gray
Write-Host ".\scripts\demo-6-monitoring.ps1      # Use throughout for monitoring" -ForegroundColor Gray
Write-Host ".\scripts\demo-7-cleanup.ps1         # Run after demo completion" -ForegroundColor Gray

Write-Host "`n" + "=" * 60 -ForegroundColor Cyan
Write-Host "Demo Environment Reset Complete!" -ForegroundColor Green