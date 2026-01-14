
param location string = resourceGroup().location
param VMName string
param LAWId string

resource DCR 'Microsoft.Insights/dataCollectionRules@2024-03-11' = {
  name: 'DCR1'
  location: location
  kind: 'Windows'
  properties: {
    destinations: {
      logAnalytics: [
       {
        workspaceResourceId: LAWId 
        name: 'Destination-LAW'
       }
      ]
    }
    dataSources: {
      windowsEventLogs: [
        {
          streams: [ 'Microsoft-Event' ]
          xPathQueries: [
            'System!*[System[(Level=1 or Level=2 or Level=3)]]'
            'Application!*[System[(Level=1 or Level=2 or Level=3)]]'
          ]

          name: 'eventLogsDataSource'
        }
      ]
    }
    dataFlows: [
      {
        streams: ['Microsoft-Event']
        destinations: ['Destination-LAW']
      }
    ]
  }
}

resource VMinscope 'Microsoft.Compute/virtualMachines@2023-09-01' existing = {
  name : VMName 
}

resource DCRassociation 'Microsoft.Insights/dataCollectionRuleAssociations@2024-03-11' = {
  name: 'link'
  scope: VMinscope
  properties: {
    dataCollectionRuleId: DCR.id
  }
}
