# First, get the Auth0 Management API token
$auth0Domain = "dev-ttiw0oehq6nnv2jk.us.auth0.com"
$clientId = "oKs0PcU5MhzDnKQqalf1xQKYLE4YsCOK"
$clientSecret = "M5aaGAZTJG4-tD7rMQMBECk9TWUHDrAMG0wCRFyFvYqOoIskj7juIdtj5BBUDpdB"

$body = @{
    client_id = $clientId
    client_secret = $clientSecret
    audience = "https://$auth0Domain/api/v2/"
    grant_type = "client_credentials"
} | ConvertTo-Json

$token = (Invoke-RestMethod -Method Post -Uri "https://$auth0Domain/oauth/token" -Body $body -ContentType "application/json").access_token

Write-Host "Getting existing resources..."

# Get existing clients
$clients = Invoke-RestMethod -Uri "https://$auth0Domain/api/v2/clients" -Headers @{Authorization = "Bearer $token"}
$clients | ForEach-Object {
    Write-Host "Client: $($_.name) (ID: $($_.client_id))"
}

# Get existing resource servers
$apis = Invoke-RestMethod -Uri "https://$auth0Domain/api/v2/resource-servers" -Headers @{Authorization = "Bearer $token"}
$apis | ForEach-Object {
    Write-Host "API: $($_.name) (Identifier: $($_.identifier))"
}

# Get existing roles
$roles = Invoke-RestMethod -Uri "https://$auth0Domain/api/v2/roles" -Headers @{Authorization = "Bearer $token"}
$roles | ForEach-Object {
    Write-Host "Role: $($_.name) (ID: $($_.id))"
}

# Get existing connections
$connections = Invoke-RestMethod -Uri "https://$auth0Domain/api/v2/connections" -Headers @{Authorization = "Bearer $token"}
$connections | ForEach-Object {
    Write-Host "Connection: $($_.name) (ID: $($_.id))"
}

# Get existing actions
$actions = Invoke-RestMethod -Uri "https://$auth0Domain/api/v2/actions" -Headers @{Authorization = "Bearer $token"}
$actions | ForEach-Object {
    Write-Host "Action: $($_.name) (ID: $($_.id))"
}