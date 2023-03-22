# Variables
$appName = "MyApp"
$keyVaultName = "MyKeyVault"
$secretName = "MyAppSecret"
$subscriptionName = "sub1"
$resourceGroup = "MyResourceGroup"
$location = "eastus"

# Connect to Azure
Connect-AzAccount

# Set the subscription context
Set-AzContext -SubscriptionName $subscriptionName

# Create a new Azure AD application
$app = New-AzADApplication -DisplayName $appName -HomePage "https://$appName" -IdentifierUris "https://$appName"

# Create a new service principal for the application
$sp = New-AzADServicePrincipal -ApplicationId $app.ApplicationId

# Generate a new secret for the application
$secret = New-AzADAppCredential -ObjectId $app.ObjectId -Password (ConvertTo-SecureString -String "MyPassword123!" -AsPlainText -Force) -EndDate (Get-Date).AddYears(1)

# Get the Key Vault object
$keyVault = Get-AzKeyVault -VaultName $keyVaultName -ResourceGroupName $resourceGroup

# Store the application secret in Key Vault
Set-AzKeyVaultSecret -VaultName $keyVault.VaultName -Name $secretName -SecretValue $secret.Secret -ContentType "text/plain"

# Grant access to the application registration in the subscription
New-AzRoleAssignment -ObjectId $app.ObjectId -Scope "/subscriptions/$($subscription.Id)" -RoleDefinitionName "Reader"
