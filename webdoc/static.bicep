targetScope = 'subscription'

param location string ='westeurope'

@description('String to make resource names unique')
var resourceToken = uniqueString(subscription().subscriptionId, location)

@description('Create a resource group')
resource rg 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: 'rg-swa-app-${resourceToken}'
  location: location
}

@description('Create a static web app')
module swa 'br/public:avm/res/web/static-site:0.9.1' = {
  name: 'client'
  scope: rg
  params: {
    name: 'swa-${resourceToken}'
    location: location
    sku: 'Free'
  }
}

@description('Output the default hostname')
output endpoint string = swa.outputs.defaultHostname

@description('Output the static web app name')
output staticWebAppName string = swa.outputs.name