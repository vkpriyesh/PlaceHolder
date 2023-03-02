param deploymentName string = 'mydeployment'
param location string[] = [
  'southeastasia'
  'eastasia'
]

var templateFile = './keyvault.bicep'
var parametersFile = './parameters.bicep'

resource deployment 'Microsoft.Resources/deployments@2020-06-01' = {
  name: deploymentName
  properties: {
    mode: '


resourceGroup: resourceGroup().name
template: templateFile
parameters: parametersFile
}
for loc in location {
name: '${deploymentName}-${loc}'
dependsOn: [
deployment
]
properties: {
mode: 'Incremental'
parameters: {
location: {
value: loc
}
keyVaultName: {
value: '${parameters('keyVaultName')}-${loc}'
}
secrets: {
value: parameters('secrets')
}
}
template: templateFile
}
}
}

az deployment sub create --name mydeployment --location eastus --template-file main.bicep
