targetScope = 'subscription'

// Built-in Policy IDs
var builtInStorageSecureTransfer = '/providers/Microsoft.Authorization/policyDefinitions/404c3081-a854-4457-ae30-26a93ef643f9'
var builtInVMPatchAssessment = '/providers/Microsoft.Authorization/policyDefinitions/59efceea-0c96-497e-a4a1-4eb2290dac15'
var builtInRequireTag = '/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99'
var builtInAllowedLocations = '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'

// Security Initiative
resource securityInitiative 'Microsoft.Authorization/policySetDefinitions@2025-03-01' = {
  name: 'security-policies-initiative'
  properties: {
    displayName: 'Security Baseline Initiative'
    policyType: 'Custom'
    metadata: {
      category: 'Security'
    }
    parameters: {
      tagName: {
        type: 'String'
        defaultValue: 'Test'
      }
    }
    policyDefinitions: [

      {
        policyDefinitionId: builtInStorageSecureTransfer
        policyDefinitionReferenceId: 'StorageSecureTransfer'
      }
      {
        policyDefinitionId: builtInVMPatchAssessment
        policyDefinitionReferenceId: 'VMPatchAssessment'
        parameters: {
          assessmentMode: { value: 'AutomaticByPlatform' }
        }
      }
      {
        policyDefinitionId: builtInRequireTag
        policyDefinitionReferenceId: 'RequireTagging'
        parameters: {
          tagName: { value: '[parameters(\'tagName\')]' }
        }
      }
      {
        policyDefinitionId: builtInAllowedLocations
        policyDefinitionReferenceId: 'AllowedLocations'
        parameters: {
          listOfAllowedLocations: { value: ['australiaeast'] }
        }
      }
    ]
  }
}

// Initiative Assignment
resource initiativeAssignment 'Microsoft.Authorization/policyAssignments@2025-03-01' = {
  name: 'security-baseline-assignment'
  location: 'australiaeast'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    displayName: 'Security Baseline Initiative Assignment'
    enforcementMode: 'DoNotEnforce'
    policyDefinitionId: securityInitiative.id
    parameters: {
      tagName: { value: 'test' }
    }
  }
}

// Role Assignment for Managed Identity (required for Modify effects)
resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, 'security-baseline', 'Contributor')
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
    principalId: initiativeAssignment.identity.principalId
    principalType: 'ServicePrincipal'
  }
}

output initiativeId string = securityInitiative.id
output assignmentId string = initiativeAssignment.id
