param vmPrefix string
param location string
param vmCount int

module vm 'vm.bicep' = [for i in range(0, vmCount): {
  name: 'vm-${i}'
  params:{
    name: '${vmPrefix}-${substring(uniqueString(resourceGroup().id), 0, 5)}-${i}'
    location: location
    vnetName:vnet.name
    subnetName: 'subnet1'
  }
}]

resource vnet 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'name'
  location: resourceGroup().location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet1'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}
