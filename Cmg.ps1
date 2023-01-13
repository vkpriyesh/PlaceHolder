# Variables for the Azure connection
$subscriptionId = "your_subscription_id"
$tenantId = "your_tenant_id"
$clientId = "your_client_id"
$clientSecret = "your_client_secret"

# Authenticate with Azure
$context = Connect-AzAccount -TenantId $tenantId -ApplicationId $clientId -Password $clientSecret

# Select the subscription
Select-AzSubscription -SubscriptionId $subscriptionId

# Get the list of databases resources
$resources = Get-AzResource -ResourceType "Microsoft.Sql/servers/databases"

# Get the date 45 days ago
$date = (Get-Date).AddDays(-45)

# Initialize an empty array to store unused databases
$unusedDatabases = @()

foreach ($resource in $resources) {
    # Get the usage details for the past 45 days
    $usage = Get-AzConsumptionUsageDetail -ResourceId $resource.Id -StartTime $date

    # Check if the usage count is 0
    if ($usage.Count -eq 0) {
        # If usage count is 0, it means the database is not used for past 45 days
        $unusedDatabases += $resource.Name
    }
}

if ($unusedDatabases.Count -gt 0) {
    Write-Host "The following databases have not been used in the past 45 days:"
    foreach ($database in $unusedDatabases) {
        Write-Host $database
    }
} else {
    Write-Host "No unused databases were found."
}
