param p_automationAccountName string
param p_location string

// Sample encrypted variables and credentials
var v_encryptedVariables = [
  {
    name: 'encryptedVar1'
    description: 'This is a sample encrypted variable'
    value: 'sampleValue1' // this value should ideally be fetched from Azure Key Vault
  }
]

var v_credentials = [
  {
    name: 'credential1'
    description: 'This is a sample credential'
    userName: 'sampleUser1'
    password: 'samplePassword1' // this value should ideally be fetched from Azure Key Vault
  }
]

// Create automation account
resource m_automationAccount 'Microsoft.Automation/automationAccounts@2022-06-01' = {
  name: p_automationAccountName
  location: p_location
  properties: {}
}

// Create encrypted variables
resource m_encryptedVariables 'Microsoft.Automation/automationAccounts/variables@2022-06-01' = [for (v_variable, i) in v_encryptedVariables: {
  name: '${p_automationAccountName}/${v_variable.name}'
  properties: {
    description: v_variable.description
    isEncrypted: true
    value: v_variable.value
  }
  dependsOn: [
    m_automationAccount
  ]
}]

// Create credentials
resource m_credentials 'Microsoft.Automation/automationAccounts/credentials@2022-06-01' = [for (v_credential, i) in v_credentials: {
  name: '${p_automationAccountName}/${v_credential.name}'
  properties: {
    description: v_credential.description
    userName: v_credential.userName
    password: v_credential.password
  }
  dependsOn: [
    m_automationAccount
  ]
}]
