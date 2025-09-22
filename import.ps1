# Import existing clients
terraform import -var-file="dev.tfvars" 'auth0_client.applications["main_api"]' "wpdnBP8JCnZSKoyt3EfcYFER4dhGMtV1"
terraform import -var-file="dev.tfvars" 'auth0_client.applications["main_app"]' "AUyDSUXLUAi0PCBxe7O87AlDCV2Wklae"
terraform import -var-file="dev.tfvars" 'auth0_client.applications["admin_dashboard"]' "cdO45c8bD96EdEeruZupBmEqd47zIIRO"
terraform import -var-file="dev.tfvars" 'auth0_client.applications["admin_api"]' "9DUwhts3DgdizuOGRyRUqpVjQS1oiQjL"

# Import existing resource servers
terraform import -var-file="dev.tfvars" 'auth0_resource_server.apis["main_api"]' "https://api.itcybersecsol.com"
terraform import -var-file="dev.tfvars" 'auth0_resource_server.apis["admin_api"]' "https://admin-api.itcybersecsol.com"
terraform import -var-file="dev.tfvars" 'auth0_resource_server.api[0]' "https://api-dev.example.com"

# Import existing roles
terraform import -var-file="dev.tfvars" 'auth0_role.roles["admin"]' "rol_ane4j9HpTt3asjvC"
terraform import -var-file="dev.tfvars" 'auth0_role.roles["user"]' "rol_uI8C8MMnSZnuRXlI"

# Import existing connection
terraform import -var-file="dev.tfvars" auth0_connection.database "con_qfGW8iGhF2DaFIGG"