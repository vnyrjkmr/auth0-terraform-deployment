@echo off
echo 🚀 GitHub CLI Authentication and Environment Setup
echo.

:: Add GitHub CLI to PATH for this session
set "PATH=%PATH%;C:\Program Files\GitHub CLI"

:: Test GitHub CLI
echo 📋 Testing GitHub CLI...
gh --version
if %errorlevel% neq 0 (
    echo ❌ GitHub CLI not working properly
    pause
    exit /b 1
)

echo ✅ GitHub CLI is available
echo.

:: Authenticate with GitHub
echo 🔐 Starting GitHub CLI authentication...
echo Please follow the authentication process in your web browser.
echo.
gh auth login --web

if %errorlevel% neq 0 (
    echo ❌ Authentication failed
    echo Please try running: gh auth login --web
    pause
    exit /b 1
)

echo ✅ Authentication successful!
echo.

:: Test authentication
echo 📋 Testing authentication...
gh auth status
if %errorlevel% neq 0 (
    echo ❌ Authentication verification failed
    pause
    exit /b 1
)

echo ✅ Ready to set up GitHub environments!
echo.

:: Run the PowerShell setup script
echo 🏗️ Running environment setup...
powershell.exe -ExecutionPolicy Bypass -File "setup-github-environments.ps1"

echo.
echo ✅ Setup completed!
pause