@description('The name of the keyvault')
param vaultName string
param keyName string

@description('The SKU of the vault to be created')
@allowed( [
  'standard'
  'premium'
]
)

param skuName string

@description('The JWT key type')
@allowed([
  'EC'
  'EC-HSM'
  'RSA'
  'RSA-HSM'
])

param keyType string

@description('Select the size of the key to be selected')
@allowed([
  2048
  3072
  4096
])

param keySize int

@description('The JsonWebKeyCurveName of the key to be created.')
@allowed([
  ''
  'P-256'
  'P-256K'
  'P-384'
  'P-521'
])
param curveName string = ''

param location string
resource keyvault 'Microsoft.KeyVault/vaults@2025-05-01' = {
  name: vaultName
  location: location
  properties: {
    sku: {
      name: skuName
      family: 'A'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enableSoftDelete: true
    enablePurgeProtection: true
    softDeleteRetentionInDays: 90
    enabledForDeployment: true
    enabledForDiskEncryption: true
  }
}

resource key 'Microsoft.KeyVault/vaults/keys@2025-05-01' = {
  parent: keyvault
  name: keyName
  properties: {
    kty: keyType
    keySize: contains(keyType, 'RSA') ? keySize : null 
    curveName: contains(curveName, 'EC') ? curveName : null

  }
}
