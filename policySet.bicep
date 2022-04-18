targetScope = 'subscription'

resource initiative 'Microsoft.Authorization/policySetDefinitions@2021-06-01' = {
  name: 'allowedLocationsdone'
  properties: {
    parameters: {
      allowedLocation: {
        type: 'Array'
        defaultValue: [
          'westeurope'
        ]
      }
    }
    policyDefinitions: [
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988'
        policyDefinitionReferenceId: 'allowedLocationForResoruceGroups'
        parameters: {
          listOfAllowedLocations: {
            value: '[parameters(\'allowedLocation\')]'
          }
        }
      }
      {
        policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
        policyDefinitionReferenceId: 'allowedLocationForResources'
        parameters: {
          listOfAllowedLocations: {
            value: '[parameters(\'allowedLocation\')]'
          }
        }
      }
    ]
  }
}
