targetScope = 'subscription'

param utc string = utcNow()
param users array = [
  '32fbff42-537c-4bf4-84ba-9e5d673b2563'
  'bc2e52ed-ccc8-49c1-b714-b87c1fe7fbaa'
  '2f6f1928-c215-4384-a28b-b5b63d97cc15'
]
param expirationDate string = '2022-05-01'
var timeSuffix = 'T00:00:18+00:00'

resource pim 'Microsoft.Authorization/roleEligibilityScheduleRequests@2020-10-01-preview' = [for user in users: {
  name: guid(user, utc)
  properties: {
    roleDefinitionId: '/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9' // user access admin
    principalId: user
    requestType: 'AdminUpdate'
    scheduleInfo: {
      startDateTime: utc
      expiration: {
        type: 'AfterDateTime'
        endDateTime: '${expirationDate}${timeSuffix}'
      }
    }
  }
}]

output ids array = [for (item, i) in users:{
  user: pim[i].properties.principalId
  pimName: pim[i].name
}]
