
targetScope = 'subscription'

param RgName string
param location string
param keyName string
param keySize int
param keyType string
param skuName string
param vaultName string
param adminUsername string
param vmName string
@secure()
param adminPassword string


resource Rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
    name: RgName
    location: location
}

module Storage 'storagemodule.bicep' = {
    scope: Rg
    params:{location:location}
}

 module keyVault 'keyvault.bicep' = {
    scope: Rg
    params: {
        location: location
        keyName: keyName
        keySize: keySize
        keyType: keyType
        skuName: skuName
        vaultName: vaultName
    }
}

module VM 'vmcreation.bicep' = {
    scope: Rg
    name: 'vmDeployment'
    params: {
        adminPassword: adminPassword 
        adminUsername: adminUsername
        vmName: vmName
    }    
}

module LAW 'Loganalytics.bicep' = {
    scope: Rg
    params: { 
        location: location
    }
}
 module DCR 'DCR.bicep' = {
    scope: Rg
    params: {
        LAWId: LAW.outputs.LAWId
        VMName: VM.outputs.VMName
    }
}

module bastion 'bastion.bicep' = {
    scope: Rg
    params: {
        PublicIP: VM.outputs.PublicIP
        VNET: VM.outputs.VNET
    }
}
module policies 'policies.bicep' = {
    name: 'Basic_policy_deployment'
}
