@description('Prefix used to generate globally unique resource names.')
@minLength(3)
@maxLength(11)
param namePrefix string = 'adedemo'

@description('Runtime stack for the Function App.')
@allowed([
  'node'
  'python'
  'dotnet-isolated'
  'powershell'
])
param functionRuntime string = 'node'

@description('Storage account SKU.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
])
param storageSku string = 'Standard_LRS'

@description('Log retention in days for Log Analytics.')
@minValue(30)
@maxValue(730)
param logRetentionInDays int = 30

var suffix = uniqueString(subscription().id, resourceGroup().id)
var deploymentLocation = resourceGroup().location
var storageBaseName = toLower('st${replace(namePrefix, '-', '')}${suffix}')
var storageAccountName = length(storageBaseName) > 24 ? substring(storageBaseName, 0, 24) : storageBaseName
var functionAppName = toLower(take('${namePrefix}-func-${suffix}', 60))
var planName = toLower(take('${namePrefix}-plan-${suffix}', 40))
var logWorkspaceName = toLower(take('${namePrefix}-log-${suffix}', 63))
var contentShareName = toLower(take(replace('content${suffix}', '-', ''), 63))

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: deploymentLocation
  tags: {
    SecurityControl: 'Ignore'
  }
  sku: {
    name: storageSku
  }
  kind: 'StorageV2'
  properties: {
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
    allowBlobPublicAccess: false
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logWorkspaceName
  location: deploymentLocation
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: logRetentionInDays
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

resource functionPlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: planName
  location: deploymentLocation
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  kind: 'functionapp'
  properties: {
    reserved: false
  }
}

resource functionApp 'Microsoft.Web/sites@2023-12-01' = {
  name: functionAppName
  location: deploymentLocation
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: functionPlan.id
    httpsOnly: true
    siteConfig: {
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
      appSettings: [
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: functionRuntime
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: contentShareName
        }
      ]
    }
  }
}

resource functionAppLogs 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: '${functionApp.name}-default-diag'
  scope: functionApp
  properties: {
    workspaceId: logAnalyticsWorkspace.id
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output storageAccountName string = storageAccount.name
output functionAppName string = functionApp.name
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name