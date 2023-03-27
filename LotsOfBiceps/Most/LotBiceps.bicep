Bicep templates automation.

Model: GPT-4

Priyesh Vk (Vk)
You are an AI programming assistant. 
- your expertise is creating bicep templates for azure infrastructure along with YML pipelines in azure devops
- you use the best of your knowledge about Bicep templates, YML, azure, azure devops, & powershell to automate infrastructure 
- Follow the user's requirements carefully & to the letter. 
- First think step-by-step — describe your plan for what to build in psuedocode, written out in great detail
- Then output the code in a single codeblock
- Minimize any other prose
- If a requirement is not technically possible, tell the user.
- If you're making changes to code you've already given the user, don't give the entire file over and over, just give them the changes so they can easily copy and paste and not wait too much

Please provide the user's requirements for the Bicep template and YML pipeline.




Priyesh Vk (Vk)
Please create bicep templates for the below mentioned azure services. Make sure to create all the templates as part of modules. In main.bicep, use those modules. List of services:
- Appservice with an app service plan
- Automation account
- Azure sql
- Data factory
- Datalake with storage account 
- Function app attached to the app service plan
- Key vault
- Log analytics workspace ID
- Logic app
- Virtual machine group

Output the necessary IDs from each template. Also create a bicep parameter file including required parameters for all the modules.

Step-by-step pseudocode:

Create Bicep module files for each Azure service
Define necessary resources and properties within each module
Create main.bicep file to import and use modules
Define necessary outputs in main.bicep
Create a Bicep parameter file for all modules
Code:

main.bicep:

bicep
Copy code
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
Create the individual module files for each Azure service in a modules folder:

appService.bicep
automationAccount.bicep
azureSql.bicep
dataFactory.bicep
dataLake.bicep
functionApp.bicep
keyVault.bicep
logAnalyticsWorkspace.bicep
logicApp.bicep
virtualMachineGroup.bicep
main.parameters.json:

json
Copy code
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appService_name": { "value": "your-app-service-name" },
    "appService_planName": { "value": "your-app-service-plan-name" },
    ...
  }
}
Fill in the required parameters for each module in main.bicep and main.parameters.json.




Priyesh Vk (Vk)
Please write bicep code for individual module file for appService.bicep

appService.bicep:

bicep
Copy code
param appServiceName string
param appServicePlanName string
param location string
param skuName string = 'F1'
param skuTier string = 'Free'
param kind string = 'app'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-01-15' = {
  name: appServicePlanName
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
}

resource appService 'Microsoft.Web/sites@2021-01-15' = {
  name: appServiceName
  location: location
  kind: kind
  properties: {
    serverFarmId: appServicePlan.id
  }
}

output appServiceId string = appService.id



Priyesh Vk (Vk)
Please write bicep code for individual module file for automationAccount.bicep

automationAccount.bicep:

bicep
Copy code
param automationAccountName string
param location string
param skuName string = 'Basic'

resource automationAccount 'Microsoft.Automation/automationAccounts@2020-01-13-preview' = {
  name: automationAccountName
  location: location
  properties: {}
  sku: {
    name: skuName
  }
}

output automationAccountId string = automationAccount.id



Priyesh Vk (Vk)
Please write bicep code for individual module file for azureSql.bicep

azureSql.bicep:

bicep
Copy code
param serverName string
param location string
param administratorLogin string
param administratorLoginPassword string
param dbName string
param sqlSkuName string = 'Standard_DS1_v2'

resource sqlServer 'Microsoft.Sql/servers@2021-05-01-preview' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    version: '12.0'
  }
}

resource sqlDb 'Microsoft.Sql/servers/databases@2021-05-01-preview' = {
  name: '${sqlServer.name}/${dbName}'
  location: location
  sku: {
    name: sqlSkuName
  }
}

output azureSqlId string = sqlDb.id



Priyesh Vk (Vk)
Please write bicep code for individual module file for dataFactory.bicep

dataFactory.bicep:

bicep
Copy code
param dataFactoryName string
param location string

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
}

output dataFactoryId string = dataFactory.id



Priyesh Vk (Vk)
Please write bicep code for individual module file for dataLake.bicep

dataLake.bicep:

bicep
Copy code
param storageAccountName string
param location string
param accountKind string = 'StorageV2'
param accessTier string = 'Hot'
param replicationType string = 'LRS'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: storageAccountName
  location: location
  kind: accountKind
  sku: {
    name: replicationType
    tier: accessTier
  }
}

resource dataLakeContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2021-06-01' = {
  parent: storageAccount
  name: 'datalake'
}

output dataLakeId string = dataLakeContainer.id



Priyesh Vk (Vk)
Please write bicep code for individual module file for functionApp.bicep

functionApp.bicep:

bicep
Copy code
param functionAppName string
param appServicePlanId string
param location string
param storageAccountConnectionString string

resource functionApp 'Microsoft.Web/sites@2021-01-15' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: storageAccountConnectionString
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: storageAccountConnectionString
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(functionAppName)
        }
      ]
    }
  }
}

output functionAppId string = functionApp.id



Priyesh Vk (Vk)
Please write bicep code for individual module file for logAnalyticsWorkspace.bicep

logAnalyticsWorkspace.bicep:

bicep
Copy code
param workspaceName string
param location string
param retentionInDays int = 30
param sku string = 'PerGB2018'

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-03-01-preview' = {
  name: workspaceName
  location: location
  properties: {
    retentionInDays: retentionInDays
  }
  sku: {
    name: sku
  }
}

output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id



Priyesh Vk (Vk)
Please write bicep code for individual module file for logicApp.bicep

logicApp.bicep:

bicep
Copy code
param logicAppName string
param location string

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: logicAppName
  location: location
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#',
      contentVersion: '1.0.0.0',
      actions: {},
      parameters: {},
      triggers: {}
    }
  }
}

output logicAppId string = logicApp.id



Priyesh Vk (Vk)
Please write bicep code for individual module file for virtualMachineGroup.bicep

virtualMachineGroup.bicep:

bicep
Copy code
param vmGroupName string
param location string
param vmSize string = 'Standard_DS1_v2'
param vmCount int = 1
param adminUsername string
param adminPassword string
param networkSecurityGroupName string

resource virtualMachineGroup 'Microsoft.Compute/virtualMachineScaleSets@2021-07-01' = {
  name: vmGroupName
  location: location
  sku: {
    name: vmSize
    capacity: vmCount
  }
  properties: {
    overprovision: false
    singlePlacementGroup: false
    upgradePolicy: {
      mode: 'Manual'
    }
    virtualMachineProfile: {
      osProfile: {
        computerNamePrefix: toLower(vmGroupName)
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      storageProfile: {
        imageReference: {
          publisher: 'Canonical'
          offer: 'UbuntuServer'
          sku: '18.04-LTS'
          version: 'latest'
        }
        osDisk: {
          createOption: 'FromImage'
          caching: 'ReadWrite'
          managedDisk: {
            storageAccountType: 'Standard_LRS'
          }
        }
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'nicconfig'
            properties: {
              primary: true
              enableAcceleratedNetworking: false
              ipConfigurations: [
                {
                  name: 'ipconfig'
                  properties: {
                    subnet: {
                      id: resourceId('Microsoft.Network/virtualNetworks/subnets', 'yourVirtualNetworkName', 'yourSubnetName')
                    }
                    loadBalancerBackendAddressPools: [
                      {
                        id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', 'yourLoadBalancerName', 'yourBackendAddressPoolName')
                      }
                    ]
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-05-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: []
  }
}

output virtualMachineGroupId string = virtualMachineGroup.id
Please replace yourVirtualNetworkName, yourSubnetName, yourLoadBalancerName, and yourBackendAddressPoolName with your own resource names, or provide parameters for them as needed.



