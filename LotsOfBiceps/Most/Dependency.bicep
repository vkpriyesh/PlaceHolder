param appServicePlanName string
param appServicePlanSku string
param appServicePlanLocation string

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: appServicePlanLocation
  sku: {
    name: appServicePlanSku
    capacity: 1
  }
}

param appServiceName string
param appServiceLocation string
param appServicePlanId string

resource appService 'Microsoft.Web/sites@2021-02-01' = {
  name: appServiceName
  location: appServiceLocation
  properties: {
    serverFarmId: appServicePlanId
  }
  dependsOn: [
    appServicePlan
  ]
}

param functionAppName string
param functionAppLocation string
param functionAppPlanId string

resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: functionAppName
  location: functionAppLocation
  properties: {
    serverFarmId: functionAppPlanId
    siteConfig: {
      appSettings: [
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
      ]
    }
  }
  dependsOn: [
    appServicePlan
  ]
}


module appServicePlan './appServicePlan.bicep' = {
  name: 'appServicePlan'
  params: {
    appServicePlanName: 'myAppServicePlan'
    appServicePlanSku: 'S1'
    appServicePlanLocation: 'eastus'
  }
}

module appService './appService.bicep' = {
  name: 'appService'
  params: {
    appServiceName: 'myAppService'
    appServiceLocation: 'eastus'
    appServicePlanId: appServicePlan.outputs.appServicePlanId
  }
}

module functionApp './functionApp.bicep' = {
  name: 'functionApp'
  params: {
    functionAppName: 'myFunctionApp'
    functionAppLocation: 'eastus'
    functionAppPlanId: appServicePlan.outputs.appServicePlanId
  }
}



