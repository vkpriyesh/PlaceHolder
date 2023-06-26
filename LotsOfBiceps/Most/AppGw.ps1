# Variables
$resourceGroup = "myResourceGroup"
$appgwName = "myAppGw"

# Fetch the application gateway
$appgw = Get-AzApplicationGateway -Name $appgwName -ResourceGroupName $resourceGroup

# Define a hashtable with backend pool details
$backendPools = @{
    "backendPool1" = @("10.1.1.4", "10.1.1.5");
    "backendPool2" = @("10.1.2.4", "10.1.2.5");
}

# Loop through the hashtable and add each backend pool to the application gateway
foreach ($poolName in $backendPools.Keys) {
    $addresses = $backendPools[$poolName]
    $backendPool = New-AzApplicationGatewayBackendAddressPool -Name $poolName -BackendIPAddresses $addresses
    $appgw = Add-AzApplicationGatewayBackendAddressPool -ApplicationGateway $appgw -Name $backendPool.Name -BackendIPAddresses $backendPool.BackendIPAddresses
}

# Update the application gateway
Set-AzApplicationGateway -ApplicationGateway $appgw

# Define array of DNS names
$dnsNames = @("www.google.com", "www.microsoft.com", "www.openai.com")

# Resolve each DNS name to its IP address(es)
foreach ($dnsName in $dnsNames) {
    try {
        # Resolve the DNS name
        $ipAddresses = [System.Net.Dns]::GetHostAddresses($dnsName)

        # Output the DNS name and its resolved IP address(es)
        Write-Output "DNS Name: $dnsName"
        foreach ($ipAddress in $ipAddresses) {
            Write-Output "  IP Address: $($ipAddress.IPAddressToString)"
        }
    }
    catch {
        Write-Output "Error resolving $dnsName : $_"
    }
}
