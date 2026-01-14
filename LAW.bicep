
param location string = resourceGroup().location

resource LAW 'Microsoft.OperationalInsights/workspaces@2025-07-01' = {
  name: 'LAW1-storage'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30 
  }
}

output LAWId string = LAW.id
