param vmProperties array

variable vmNamePrefix string = "vm"

resource vmArray 'Microsoft.Compute/virtualMachines@2020-06-01' = [for i in range(0, length(parameters.vmProperties)) : {
  name: "${vmNamePrefix}${i}"
  properties: {
    hardwareProfile: {
      vmSize: vmProperties[i].vmSize
    },
    osProfile: {
      computerName: "${vmNamePrefix}${i}",
      adminUsername: vmProperties[i].adminUsername,
      adminPassword: vmProperties[i].adminPassword
    },
    storageProfile: {
      imageReference: {
        publisher: vmProperties[i].imageReference.publisher,
        offer: vmProperties[i].imageReference.offer,
        sku: vmProperties[i].imageReference.sku,
        version: vmProperties[i].imageReference.version
      }
    }
  }
}]
