# Parameters
param(
    [string]$resourceGroupName,
    [string]$automationAccountName,
    [string]$configurationName,
    [string]$configurationPath,
    [string]$configurationDataPath
)

# Import the DSC configuration
Import-AzAutomationDscConfiguration -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -SourcePath $configurationPath -Published -Force

# Compile the DSC configuration
$compilationJob = Start-AzAutomationDscCompilationJob -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -ConfigurationName $configurationName -ConfigurationDataPath $configurationDataPath
$compilationJob | Wait-AzAutomationDscCompilationJob
# Parameters
param(
    [string]$subscriptionId,
    [string]$resourceGroupName,
    [string]$automationAccountName,
    [string]$vmName,
    [string]$configurationName,
    [string]$configurationPath,
    [string]$configurationDataPath
)

# Login to Azure
Connect-AzAccount

# Select the correct subscription
Set-AzContext -SubscriptionId $subscriptionId

# Register the VM as DSC Node
Register-AzAutomationDscNode -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -AzureVMName $vmName -NodeConfigurationName $configurationName

# Import the configuration
Import-AzAutomationDscConfiguration -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -SourcePath $configurationPath -Published -Force

# Compile the DSC configuration
$compilationJob = Start-AzAutomationDscCompilationJob -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -ConfigurationName $configurationName -ConfigurationDataPath $configurationDataPath
$compilationJob | Wait-AzAutomationDscCompilationJob

# Get Node Id of the VM
$nodeId = (Get-AzAutomationDscNode -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName | Where-Object {$_.Name -eq $vmName}).Id

# Start the DSC configuration deployment
Start-AzAutomationDscNodeConfigurationDeployment -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -NodeConfigurationName $configurationName -NodeId $nodeId
# Parameters
param(
    [string]$resourceGroupName,
    [string]$automationAccountName,
    [string]$configurationName,
    [string]$configurationDataPath
)

# Define the DSC configuration
$configurationContent = Get-Content -Path 'path-to-your-dsc-file' -Raw
Invoke-Expression -Command $configurationContent

# Export the configuration to a .mof file
$configurationName -OutputPath '.\'

# Import the DSC configuration
Import-AzAutomationDscConfiguration -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -SourcePath ".\$configurationName.ps1" -Published -Force

# Compile the DSC configuration
$compilationJob = Start-AzAutomationDscCompilationJob -ResourceGroupName $resourceGroupName -AutomationAccountName $automationAccountName -ConfigurationName $configurationName -ConfigurationDataPath $configurationDataPath
$compilationJob | Wait-AzAutomationDscCompilationJob
