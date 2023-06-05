
# Import the required modules
Import-Module Az.Accounts
Import-Module Az.Automation

# Login to Azure account
$credential = Get-Credential
Connect-AzAccount -Credential $credential

# Select the subscription
$subscriptionId = 'Your-Azure-Subscription-Id'
Set-AzContext -SubscriptionId $subscriptionId

# Define the path of the DSC configuration file
$dscFilePath = 'Path-to-your-DSC-file'

# Import the DSC configuration
Configuration ImportDscConfiguration
{
    Import-DscResource -Path $dscFilePath
}
ImportDscConfiguration

# Compile the DSC configuration
Start-DscConfiguration -Path .\ImportDscConfiguration -Wait -Verbose

# Register an Azure VM node
$resourceGroupName = 'Your-Azure-Resource-Group'
$automationAccountName = 'Your-Automation-Account'
$nodeConfigurationName = 'Your-Node-Configuration-Name'
$vmName = 'Your-Azure-VM-Name'

Register-AzAutomationDscNode -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -AzureVMName $vmName -ConfigurationName $nodeConfigurationName -NodeConfigurationName $nodeConfigurationName -RebootNodeIfNeeded $true -ActionAfterReboot ContinueConfiguration -ConfigurationMode ApplyAndAutoCorrect

# Apply the DSC configuration to the Azure VM
Start-AzAutomationDscCompilationJob -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -ConfigurationName $nodeConfigurationName
# Import the required modules
Import-Module Az.Accounts
Import-Module Az.Automation

# Login to Azure account
$credential = Get-Credential
Connect-AzAccount -Credential $credential

# Select the subscription
$subscriptionId = 'Your-Azure-Subscription-Id'
Set-AzContext -SubscriptionId $subscriptionId

# Define hashtable containing module names and URLs
$modules = @{
    ModuleName1 = 'ModuleUrl1'
    ModuleName2 = 'ModuleUrl2'
}

# Define automation account and resource group
$resourceGroupName = 'Your-Azure-Resource-Group'
$automationAccountName = 'Your-Automation-Account'

# Import the modules
foreach($moduleName in $modules.Keys) {
    $moduleUrl = $modules[$moduleName]
    New-AzAutomationModule -AutomationAccountName $automationAccountName -ResourceGroupName $resourceGroupName -ContentLinkUri $moduleUrl -Name $moduleName
}