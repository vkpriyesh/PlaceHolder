param keyVaultName string
param location string
param vnetName string
param vnetResourceGroupName string
param subnetName string

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroupName)
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-02-01' existing = {
  name: subnetName
  parent: vnet
}

resource keyVaultResource 'Microsoft.KeyVault/vaults@2021-06-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      virtualNetworkRules: [
        {
         
          id: subnet.id
        }
      ]
      ipRules: []
    }
  }
}



Main.bucep

param keyVaultName string
param location string = resourceGroup().location
param vnetName string
param vnetResourceGroupName string
param subnetName string

module keyVault './keyVault.bicep' = {
  name: 'keyVaultModule'
  params: {
    keyVaultName: keyVaultName
    location: location
    vnetName: vnetName
    vnetResourceGroupName: vnetResourceGroupName
    subnetName: subnetName
  }
}

