param location string
param keyVaultName string
param secrets array

resource keyVault 'Microsoft.KeyVault/vaults@2021-04-01-preview' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      name: 'standard'
      family: 'A'
    }
    accessPolicies: []
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    tenantId: subscription().tenantId
  }
}

for secret in secrets {
  resource secretResource '${keyVaultName}/${secret.name}@2021-04-01-preview' = {
    name: secret.name
    type: 'secrets'
    properties: {
      value: secret.value
    }
    dependsOn: [
      keyVault
    ]
  }
}
