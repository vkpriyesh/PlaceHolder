$subscriptionId = "<Your Azure Subscription ID>"
$resourceGroupName = "<Your Resource Group Name>"
$automationAccountName = "<Your Automation Account Name>"

# Login to Azure
Connect-AzAccount

# Select the subscription
Set-AzContext -SubscriptionId $subscriptionId

# List of all the modules
$modules = Get-AzAutomationModule -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName

# Function to check if all modules are available
function AreAllModulesAvailable($modules) {
    foreach($module in $modules) {
        if($module.ProvisioningState -ne "Succeeded") {
            return $false
        }
    }
    return $true
}

# Loop until all modules are available
while(-not (AreAllModulesAvailable($modules))) {
    foreach($module in $modules) {
        $status = Get-AzAutomationModule -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -Name $module.Name
        Write-Output ("Module: " + $module.Name + " Status: " + $status.ProvisioningState)
    }
    Start-Sleep -Seconds 60
    $modules = Get-AzAutomationModule -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName
}

Write-Output "All modules are available"
