
param namePrefix string = 'storage1'
param location string

var storageAccountName = '${namePrefix}${uniqueString(resourceGroup().id)}'
resource storageAccount 'Microsoft.Storage/storageAccounts@2025-06-01' = {
    name: storageAccountName
    location: location
    sku: {
        name: 'Standard_LRS'
    }
    kind: 'StorageV2'
}

resource blobservice 'Microsoft.Storage/storageAccounts/blobServices@2025-06-01' = {
  parent: storageAccount
  name: 'default'
}

resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-06-01' = {
  parent: blobservice
  name: 'images'
  properties: {publicAccess:'None'}
}

resource defforstorage 'Microsoft.Security/defenderForStorageSettings@2025-07-01-preview' = {
  name: 'current'
  scope: storageAccount
  properties: {
    isEnabled: true
    malwareScanning: {
      onUpload: {
      isEnabled: true
      capGBPerMonth: 5000
     }
   }
    sensitiveDataDiscovery: {
    isEnabled: true
}
 overrideSubscriptionLevelSettings: true
 }
}

