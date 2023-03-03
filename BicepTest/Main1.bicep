param keyVaultName string
param secret1Value string
param secret2Value string

module keyVaultModule './keyVault.bicep' = {
  name: 'keyVault'
  params: {
    keyVaultName: keyVaultName
    secret1Value: secret1Value
    secret2Value: secret2Value
  }
}

output keyVaultResourceId string = keyVaultModule.outputs.keyVault.id
