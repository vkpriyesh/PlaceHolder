param appServiceName string
param appServicePlanName string
param location string = resourceGroup().location
param sku string = 'F1'
param tier string = 'Free'

module appServicePlan './appServicePlan.bicep' = {
  name: 'appServicePlanModule'
  params: {
    appServicePlanName: appServicePlanName
    location: location
    sku: sku
    tier: tier
  }
}

module appService './appService.bicep' = {
  name: 'appServiceModule'
  params: {
    appServiceName: appServiceName
    location: location
    appServicePlanId: appServicePlan.outputs.appServicePlanId
  }
  dependsOn: [
    appServicePlan
  ]
}

param appServicePlanName string
param location string
param sku string
param tier string

resource appServicePlanResource 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: sku
    tier: tier
  }
}

output appServicePlanId string = appServicePlanResource.id

param appServiceName string
param location string
param appServicePlanId string

resource appServiceResource 'Microsoft.Web/sites@2021-02-01' = {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: appServicePlanId
  }
}

output appServiceId string = appServiceResource.id

