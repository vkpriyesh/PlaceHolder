param keyVaultName string
param secret1Value string
param secret2Value string

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: keyVaultName
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' // replace with your own object ID
        permissions: {
          keys: ['get', 'list']
          secrets: ['get', 'list']
        }
      }
    ]
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
  }
}

var secrets = [  'secret1',  'secret2']

for secretName in secrets {
  resource "${secretName}_secret" 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = {
    name: '${keyVaultName}/${secretName}'
    properties: {
      value: if (secretName == 'secret1') {
        secret1Value
      } else {
        secret2Value
      }
    }
    dependsOn: [
      keyVault
    ]
  }
}
