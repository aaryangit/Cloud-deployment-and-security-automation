
param adminUsername string
@secure()
param adminPassword string
param publicIpName string = 'myPublicIP'
param publicIpSku string = 'Standard'
param OSVersion string = '2022-datacenter-azure-edition'
param vmSize string = 'Standard_D4ds_v4'
@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${vmName}-${uniqueString(resourceGroup().id, vmName)}')
param location string = resourceGroup().location
param vmName string 

var nicName = 'Nic1'
var addressPrefix = '10.0.0.0/16'
var subnetName = 'subnet'
var subnetPrefix = '10.0.10.0/24'
var VNetName = 'testVnet'
var NSGName = 'default-NSG'

resource PublicIP 'Microsoft.Network/publicIPAddresses@2025-01-01' = {
  name: publicIpName
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  dnsSettings: {
    domainNameLabel: dnsLabelPrefix
  }
  }
}

resource NSG 'Microsoft.Network/networkSecurityGroups@2025-01-01' = {
  name: NSGName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-RDP'
        properties: {
        priority: 1000 
        access: 'Allow'
        protocol: 'Tcp'
        direction: 'Inbound' 
        destinationPortRange: '3389'
        sourcePortRange: '*'
        sourceAddressPrefix: '*'
        destinationAddressPrefix: '*'

      }
      }
    ]
  }
}

resource Vnet 'Microsoft.Network/virtualNetworks@2025-01-01' = {
  name: VNetName
  location: location
  properties: {
    addressSpace: { 
      addressPrefixes:[ addressPrefix 
    ]
    }
    subnets: [
      {
        name: subnetName 
        properties: {
          addressPrefix: subnetPrefix
          networkSecurityGroup: {id: NSG.id}
        }
      }
    ]
  }
}

resource NIC 'Microsoft.Network/networkInterfaces@2025-01-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      { 
        name: 'Ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', VNetName, subnetName)
          }
       }
      }
    ]
  
  }
  dependsOn: [
    Vnet
  ]
}

resource VM 'Microsoft.Compute/virtualMachines@2025-04-01' = {
  name: vmName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {id: NIC.id}
      ]
    }

    diagnosticsProfile: {
       bootDiagnostics: {
        enabled: true
       }
    }
  }
}

resource vmAMA 'Microsoft.Compute/virtualMachines/extensions@2025-04-01' = {
  parent: VM
  name: 'AzureMonitorWindowsAgent'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.Monitor'
    type: 'AzureMonitorWindowsAgent'
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
}

output VMId string = VM.id 
output VMName string = VM.name
output VNET string = Vnet.name
output PublicIP string = PublicIP.name
