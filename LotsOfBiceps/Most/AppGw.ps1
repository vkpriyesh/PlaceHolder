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
# Variables
$resourceGroup = "yourResourceGroup"
$appGwName = "yourAppGw"
$poolName = "yourBackendPool"
$backendIPs = @("10.0.0.4", "10.0.0.5")  # replace with your backend IPs

# Fetch the application gateway
$appGw = Get-AzApplicationGateway -Name $appGwName -ResourceGroupName $resourceGroup

# Create a new backend pool
$backendPool = New-AzApplicationGatewayBackendAddressPool -Name $poolName

# Add backend addresses to the backend pool
foreach ($ip in $backendIPs) {
    $backendAddress = New-AzApplicationGatewayBackendAddress -IpAddress $ip
    $backendPool.BackendIPAddresses.Add($backendAddress)
}

# Add the backend pool to the application gateway
$appGw.BackendAddressPools.Add($backendPool)

# Update the application gateway
Set-AzApplicationGateway -ApplicationGateway $appGw

# Variables
$resourceGroup = "yourResourceGroup"
$appGwName = "yourAppGw"
$poolName = "yourBackendPool"
$backendIPs = @("10.0.0.4", "10.0.0.5")  # replace with your backend IPs

# Fetch the application gateway
$appGw = Get-AzApplicationGateway -Name $appGwName -ResourceGroupName $resourceGroup

# Create a new backend pool
$backendPool = New-AzApplicationGatewayBackendAddressPool -Name $poolName

# Check if BackendIPAddresses is null and if so, create a new list
if ($null -eq $backendPool.BackendIPAddresses) {
    $backendPool.BackendIPAddresses = New-Object 'system.collections.generic.list[Microsoft.Azure.Commands.Network.Models.PSApplicationGatewayBackendAddress]'
}

# Add backend addresses to the backend pool
foreach ($ip in $backendIPs) {
    $backendAddress = New-AzApplicationGatewayBackendAddress -IpAddress $ip
    $backendPool.BackendIPAddresses.Add($backendAddress)
}

# Check if BackendAddressPools is null and if so, create a new list
if ($null -eq $appGw.BackendAddressPools) {
    $appGw.BackendAddressPools = New-Object 'system.collections.generic.list[Microsoft.Azure.Commands.Network.Models.PSApplicationGatewayBackendAddressPool]'
}

# Add the backend pool to the application gateway
$appGw.BackendAddressPools.Add($backendPool)

# Update the application gateway
Set-AzApplicationGateway -ApplicationGateway $appGw
# Parse JSON file to get the FQDNs
$fqdns = (Get-Content -Path 'path_to_your_json_file.json' | ConvertFrom-Json).fqdns

# Iterate over each FQDN
foreach ($fqdn in $fqdns) {
    # Resolve the FQDN to an IP address
    try {
        $ipAddress = [System.Net.Dns]::GetHostAddresses($fqdn) | Where-Object { $_.AddressFamily -eq 'InterNetwork' } | Select-Object -ExpandProperty IPAddressToString -First 1
        Write-Host "$fqdn is resolved to IP Address $ipAddress"
    } catch {
        Write-Host "Failed to resolve $fqdn to an IP Address"
    }
}

