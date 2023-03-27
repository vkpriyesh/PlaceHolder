// Modules
module appService './modules/appService.bicep' = {
  name: 'appServiceModule'
  params: { ... }
}

module automationAccount './modules/automationAccount.bicep' = {
  name: 'automationAccountModule'
  params: { ... }
}

module azureSql './modules/azureSql.bicep' = {
  name: 'azureSqlModule'
  params: { ... }
}

module dataFactory './modules/dataFactory.bicep' = {
  name: 'dataFactoryModule'
  params: { ... }
}

module dataLake './modules/dataLake.bicep' = {
  name: 'dataLakeModule'
  params: { ... }
}

module functionApp './modules/functionApp.bicep' = {
  name: 'functionAppModule'
  params: { ... }
}

module keyVault './modules/keyVault.bicep' = {
  name: 'keyVaultModule'
  params: { ... }
}

module logAnalyticsWorkspace './modules/logAnalyticsWorkspace.bicep' = {
  name: 'logAnalyticsWorkspaceModule'
  params: { ... }
}

module logicApp './modules/logicApp.bicep' = {
  name: 'logicAppModule'
  params: { ... }
}

module virtualMachineGroup './modules/virtualMachineGroup.bicep' = {
  name: 'virtualMachineGroupModule'
  params: { ... }
}

// Outputs
output appServiceId string = appService.outputs.appServiceId
output automationAccountId string = automationAccount.outputs.automationAccountId
output azureSqlId string = azureSql.outputs.azureSqlId
output dataFactoryId string = dataFactory.outputs.dataFactoryId
output dataLakeId string = dataLake.outputs.dataLakeId
output functionAppId string = functionApp.outputs.functionAppId
output keyVaultId string = keyVault.outputs.keyVaultId
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.outputs.logAnalyticsWorkspaceId
output logicAppId string = logicApp.outputs.logicAppId
output virtualMachineGroupId string = virtualMachineGroup.outputs.virtualMachineGroupId
