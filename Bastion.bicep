
param location string = resourceGroup().location
param VNET string
param PublicIP string

resource PublicIPRef 'Microsoft.Network/publicIPAddresses@2025-01-01' existing = {
  name: PublicIP
}

resource VNETReference 'Microsoft.Network/virtualNetworks@2025-01-01' existing = {
  name: VNET 
}

resource bastionsubnet 'Microsoft.Network/virtualNetworks/subnets@2025-01-01' = {
  parent: VNETReference
  name: 'AzureBastionSubnet'
  properties: {
    addressPrefix: '10.0.1.0/26'
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2025-01-01' = {
  location: location
  name: 'testbastion'
  properties: {
    ipConfigurations: [
      { 
        name: 'testconfig'
        properties: {
          subnet: {
            id: bastionsubnet.id
          }
          publicIPAddress: {
            id: PublicIPRef.id
          }
        }
      }
    ]
  }
  sku: { 
    name: 'Standard'
  }
}
