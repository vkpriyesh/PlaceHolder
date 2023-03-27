function New-SecureSecret {
    param (
        [int]$length = 41
    )

    $random = New-Object -TypeName System.Security.Cryptography.RNGCryptoServiceProvider
    $bytes = New-Object -TypeName 'byte[]' -ArgumentList $length
    $random.GetBytes($bytes)

    return [System.Convert]::ToBase64String($bytes)
}

param (
    [string]$applicationName,
    [string]$subscriptionName,
    [string]$resourceGroupName
)

# Sign in to Azure account (if not already signed in)
$context = Get-AzContext
if ($null -eq $context) {
    Connect-AzAccount
}

# Set Azure subscription context
Select-AzSubscription -SubscriptionName $subscriptionName

# Create Azure AD App registration
$appDisplayName = "someApp-$applicationName-sp"
$app = New-AzADApplication -DisplayName $appDisplayName

# Create a service principal
$servicePrincipal = New-AzADServicePrincipal -ApplicationId $app.ApplicationId

# Create a secret for the App registration
$secretEndDate = (Get-Date).AddYears(1)
$secretValue = New-SecureSecret
$secret = New-AzADAppCredential -ApplicationId $app.ApplicationId -EndDate $secretEndDate -Password $secretValue

# Grant contributor role to the service principal at the resource group scope
$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName
New-AzRoleAssignment -ObjectId $servicePrincipal.Id -RoleDefinitionName 'Contributor' -Scope $resourceGroup.ResourceId

# Get the subscription details
$subscription = Get-AzSubscription -SubscriptionName $subscriptionName

# Sign in to Azure DevOps
$adoPersonalAccessToken = 'your-personal-access-token'
$organizationUrl = 'https://dev.azure.com/your-organization-name'
$projectName = 'your-project-name'
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f "", $adoPersonalAccessToken)))

# Create Azure DevOps service connection
$serviceConnectionName = "someApp-$applicationName-sc"

$serviceConnection = @{
    name = $serviceConnectionName
    type = 'azurerm'
    authorization = @{
        scheme = 'ServicePrincipal'
        parameters = @{
            tenantid = $subscription.TenantId
            serviceprincipalid = $app.ApplicationId
            authenticationType = 'spnKey'
            serviceprincipalkey = $secretValue
        }
    }
    data = @{
        subscriptionId = $subscription.Id
        subscriptionName = $subscription.Name
        environment = 'AzureCloud'
        scopeLevel = 'Subscription'
        resourceGroupName = $resourceGroupName
    }
}

$restApiUrl = "$organizationUrl/$projectName/_apis/serviceendpoint/endpoints?api-version=6.0-preview.4"
$response = Invoke-RestMethod -Uri $restApiUrl -Method Post -ContentType "application/json" -Body (ConvertTo-Json $serviceConnection) -Headers @{Authorization=("Basic {0}" -f $base64AuthInfo)}
