# Environment Protection Rules Setup

This guide helps you configure approval gates for production deployments to ensure safe and controlled infrastructure changes.

## 🔒 Why Environment Protection is Important

- **Prevents accidental production deployments**
- **Requires manual review of Terraform plans before applying**
- **Adds audit trail for production changes**
- **Allows for deployment rollback planning**

## 📋 Step-by-Step Setup

### 1. Navigate to Environment Settings

**Method 1: Direct Link**
- Go to: [Repository Environment Settings](https://github.com/KaranGupta05/teraform_auth0/settings/environments)



**Method 2: Manual Navigation**
1. Go to your repository: https://github.com/KaranGupta05/teraform_auth0
2. Click the **"Settings"** tab (next to Code, Issues, Pull requests)
3. In the left sidebar, scroll down to **"Environments"** under "Code and automation"
4. Click **"Environments"**

**What You Should See**:
- Page title: "Environments" 
- Three environment cards: `development`, `production`, `staging`
- Each card shows deployment count and last deployment time
- "Configure" button on each environment card

### 2. Configure Production Environment

**Step 2a: Navigate to Production Environment**
1. Go to: https://github.com/KaranGupta05/teraform_auth0/settings/environments
2. You should see three environments: `development`, `production`, and `staging`
3. Click on the **"production"** environment name (not the configure button)

**Step 2b: Add Protection Rules**
Once you're in the production environment settings page:

#### Required Reviewers
1. **Scroll down** to find the "Environment protection rules" section
2. **Check the box** for "Required reviewers"
3. **Click "Add up to 6 reviewers"** 
4. **Type usernames** of team members who can approve (e.g., your GitHub username)
5. **Select users** from the dropdown that appears
6. **Optional**: Check "Prevent self-review" for additional security

*Example: If your team members are @john-doe and @jane-smith, add both*

#### Wait Timer (Deployment Delay)
1. **Check the box** for "Wait timer"
2. **Enter "15"** in the minutes field
3. This creates a 15-minute delay before deployment can proceed after approval

#### Deployment Branch Policy
1. **Scroll down** to "Deployment branches" section
2. **Select "Protected branches"** radio button
3. **Click "Add deployment branch rule"**
4. **Type "main"** in the branch name field
5. **Click "Add rule"**
6. **Repeat** for "master" branch if you use both
7. **Alternative**: Select "Selected branches" and add specific branch patterns

**Step 2c: Save Configuration**
1. **Scroll to bottom** of the page
2. **Click "Save protection rules"** button
3. You should see a success message: "Environment protection rules updated"

### 3. Configure Staging Environment (Recommended)

Click on the **"staging"** environment:

- ✅ **1 required reviewer** (for validation testing)
- ✅ **5-minute wait timer** (shorter than production)
- ✅ **Allow deployment from**: `release/*`, `hotfix/*`, `main`, `master`

### 4. Development Environment

The **"development"** environment should remain **without restrictions** for fast iteration.

## 🚀 How Approvals Work in the Workflow

### Before Approval
1. **Terraform Plan** runs automatically and shows what changes will be made
2. **Plan details** are posted as PR comments for review
3. **Deployment job** waits for approval in GitHub Actions

### During Approval
1. **Designated reviewers** get notified of pending deployment
2. **Reviewers can examine**:
   - Terraform plan output
   - Files being changed
   - Commit history
3. **Reviewers approve or reject** the deployment

### After Approval
1. **Wait timer** starts (if configured)
2. **Terraform Apply** runs automatically
3. **Deployment summary** is generated
4. **Release tag** is created for production deployments

## 📧 Approval Notifications

Team members will receive notifications via:
- **GitHub notifications** (in-app and email)
- **Slack** (if GitHub Slack app is configured)
- **Teams** (if GitHub Teams app is configured)

## 🔄 Emergency Bypasses

### Admin Override
- Repository admins can bypass protection rules if needed
- Use only for emergency hotfixes
- Document the reason in deployment notes

### Workflow Dispatch
- Use manual workflow triggers for emergency deployments
- Still requires environment approvals
- Useful for off-hours deployments

## 📊 Monitoring and Auditing

All deployments are tracked in:
- **GitHub Actions logs** - Full deployment history
- **Environment deployment history** - Per-environment tracking  
- **Release tags** - Production deployment markers
- **Git commit history** - Change tracking

## 🚨 Best Practices

### For Reviewers
- ✅ **Always review the Terraform plan** before approving
- ✅ **Check for destructive changes** (resource deletions)
- ✅ **Verify the source branch** matches expectations
- ✅ **Coordinate with team** for major changes

### For Developers
- ✅ **Test thoroughly** in development and staging first
- ✅ **Write clear commit messages** explaining changes
- ✅ **Update documentation** for infrastructure changes
- ✅ **Plan rollback strategy** before production deployment

## 🔧 Troubleshooting

### Can't Find Environment Settings
**Problem**: No environments visible in settings
**Solution**: 
1. Ensure environments are created first by running the setup script
2. Go to Actions tab and run any workflow to create environments automatically
3. Check that you have admin access to the repository

### Can't Add Reviewers
**Problem**: "Add reviewers" option is grayed out or not working
**Solutions**:
1. **Check repository plan**: Free GitHub accounts have limited environment features
2. **Verify permissions**: You need admin access to configure environment protection
3. **Add collaborators first**: Users must have repository access before being added as reviewers
4. **Use GitHub usernames**: Enter exact GitHub usernames (e.g., `KaranGupta05`)

### Deployment Branch Policy Not Working
**Problem**: Can't restrict to specific branches
**Solutions**:
1. **Use "Selected branches"** instead of "Protected branches"
2. **Add branch patterns** like `main`, `master`, or `refs/heads/main`
3. **Check branch names**: Ensure branch names match exactly (case-sensitive)
4. **Use wildcards**: Try patterns like `release/*` for release branches

### Approval Not Triggering
**Common Issues**:
- ✅ Check if reviewers are correctly added to environment
- ✅ Verify reviewers have repository access
- ✅ Ensure GitHub notifications are enabled
- ✅ Confirm the workflow is targeting the correct environment

### Deployment Stuck in "Waiting"
**Debugging Steps**:
1. **Check GitHub Actions logs** for specific error messages
2. **Verify all required approvals** are received
3. **Check wait timer** hasn't been exceeded (shows remaining time)
4. **Look for environment protection rule conflicts**
5. **Ensure branch matches** deployment branch policy

### "Environment not found" Errors
**Problem**: Workflow fails with environment not found
**Solution**:
1. **Run the setup script** first: `.\scripts\setup-end-to-end.ps1 -SetupEnvironments`
2. **Manually create environments** at repository settings
3. **Check environment names** match exactly: `development`, `staging`, `production`

### Emergency Deployment Needed
**Options**:
1. **Workflow Dispatch**: Use manual trigger with force_deploy (still requires approval)
2. **Admin Override**: Repository admins can bypass protection temporarily
3. **Hotfix Branch**: Use emergency branch that bypasses some restrictions
4. **Document Emergency**: Always document the reason for emergency deployments

## 🖼️ Visual Walkthrough

### Screenshot 1: Environment Settings Page
When you navigate to the environments page, you should see:
```
Environments
├── development (✅ No protection rules needed)
├── production (🔒 Click to configure)  
└── staging (⚙️ Optional configuration)
```

### Screenshot 2: Production Environment Configuration
After clicking on "production", look for these sections:

```
Environment protection rules
┌─────────────────────────────────────────┐
│ ☐ Required reviewers                    │
│ ☐ Wait timer                           │
│ ☐ Prevent self-review                  │
└─────────────────────────────────────────┘

Deployment branches
┌─────────────────────────────────────────┐
│ ◉ Any branch                           │
│ ○ Protected branches                   │  
│ ○ Selected branches                    │
└─────────────────────────────────────────┘
```

### Screenshot 3: Adding Reviewers
1. **Check "Required reviewers"** ☑️
2. **Click "Add up to 6 reviewers"** button
3. **Type GitHub username** in the search box
4. **Select user** from dropdown list
5. **Repeat** for additional reviewers

### Screenshot 4: Setting Wait Timer
1. **Check "Wait timer"** ☑️  
2. **Enter minutes** in number field (e.g., "15")
3. **Note**: This appears as "Wait 15 minutes before allowing deployments to proceed"

### Screenshot 5: Branch Protection
1. **Select "Selected branches"** radio button ◉
2. **Click "Add deployment branch rule"** 
3. **Enter branch name**: `main`
4. **Click "Add rule"** 
5. **Repeat for**: `master` (if needed)

---

## 🎯 Quick Setup Checklist

**Prerequisites**:
- [ ] Run setup script to create environments: `.\scripts\setup-end-to-end.ps1 -SetupEnvironments`
- [ ] Verify you have admin access to the repository
- [ ] Ensure team members have repository access

**Production Environment Setup**:
- [ ] Navigate to: https://github.com/KaranGupta05/teraform_auth0/settings/environments
- [ ] Click on "production" environment
- [ ] ☑️ Check "Required reviewers"
- [ ] Add 1-2 team members as reviewers
- [ ] ☑️ Check "Wait timer" and set to "15" minutes
- [ ] ☑️ Check "Prevent self-review" (recommended)
- [ ] Select "Selected branches" for deployment branches
- [ ] Add branch rule for "main"
- [ ] Add branch rule for "master" (if applicable)
- [ ] Click "Save protection rules"

**Staging Environment Setup (Optional)**:
- [ ] Click on "staging" environment  
- [ ] Add 1 required reviewer
- [ ] Set 5-minute wait timer
- [ ] Allow deployment from: `release/*`, `hotfix/*`, `main`

**Testing**:
- [ ] Test deployment flow with a small change
- [ ] Verify notifications reach the right people
- [ ] Confirm approval process works end-to-end
- [ ] Document emergency procedures for your team

**Need help?** Check the [GitHub Environments Documentation](https://docs.github.com/en/actions/deployment/targeting-different-environments/using-environments-for-deployment) for more details.

## 📞 Quick Help

If you're still having trouble, try these commands to check your setup:

```powershell
# Verify environments exist
gh api repos/KaranGupta05/teraform_auth0/environments

# List repository collaborators (potential reviewers)  
gh api repos/KaranGupta05/teraform_auth0/collaborators

# Check your repository permissions
gh api repos/KaranGupta05/teraform_auth0 --jq '.permissions'
```