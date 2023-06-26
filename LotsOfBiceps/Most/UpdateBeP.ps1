# Parse JSON file to get the backend settings list
$backendSettingsList = (Get-Content -Path 'path_to_your_json_file.json' | ConvertFrom-Json).backendSettingList

$appGatewayName = 'YourApplicationGatewayName'
$resourceGroupName = 'YourResourceGroupName'

foreach ($backendSetting in $backendSettingsList) {
    $backendPoolName = $backendSetting.name
    $backendAddresses = $backendSetting.properties.backendAddresses.ipAddress

    # Check if backend pool already exists
    $existingBackendPool = az network application-gateway address-pool show --gateway-name $appGatewayName --name $backendPoolName --resource-group $resourceGroupName --output json | ConvertFrom-Json

    if ($null -eq $existingBackendPool) {
        # If backend pool doesn't exist, create a new one with the first IP address
        az network application-gateway address-pool create --gateway-name $appGatewayName --name $backendPoolName --servers $backendAddresses[0] --resource-group $resourceGroupName
    }

    # If there are additional IP addresses, add them to the existing backend pool
    if ($backendAddresses.Count -gt 1) {
        for ($i = 1; $i -lt $backendAddresses.Count; $i++) {
            $existingBackendPool.backendAddresses += @{ "ipAddress" = $backendAddresses[$i] }

            # Convert updated backend pool to JSON and update it using Azure CLI
            $updatedBackendPoolJson = $existingBackendPool | ConvertTo-Json -Compress
            az network application-gateway address-pool update --gateway-name $appGatewayName --name $backendPoolName --resource-group $resourceGroupName --set $updatedBackendPoolJson
        }
    }
}
