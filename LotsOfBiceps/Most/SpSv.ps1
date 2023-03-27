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
$secretValue = 'your-secret-value'
$secret = New-AzADAppCredential -ApplicationId $app.ApplicationId -EndDate $secretEndDate -Password $secretValue

# Grant contributor role to the service principal at the resource group scope
$resourceGroup = Get-AzResourceGroup -Name $resourceGroupName
New-AzRoleAssignment -ObjectId $servicePrincipal.Id -RoleDefinitionName 'Contributor' -Scope $resourceGroup.ResourceId

# Get the subscription details
$subscription = Get-AzSubscription -SubscriptionName $subscriptionName

# Sign in to Azure DevOps
$adoPersonalAccessToken = 'your-personal-access-token'
$organizationUrl = 'https://dev.azure.com/your-organization-name'
Connect-AzDevOps -Organization $organizationUrl -AccessToken $adoPersonalAccessToken

# Create Azure DevOps service connection
$serviceConnectionName = "someApp-$applicationName-sc"
$projectName = 'your-project-name'

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

Invoke-AzDevOpsRestMethod -Organization $organizationUrl -Project $projectName -Area 'serviceendpoint' -Resource 'endpoints' -Method POST -Body $serviceConnection -ApiVersion '6.0-preview.4'
