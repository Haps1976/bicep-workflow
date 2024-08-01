param iprule array = []
param virtualNetworkRules array = []
param sku_name  string = 'Standard_LRS'
var storage_account_prefix = 'st'
var storage_account_name = '${storage_account_prefix}${uniqueString(resourceGroup().name)}'
var networkAcls = {
  bypass: 'AzureServices'
  ipRules:iprule
  virtualNetworkRules: virtualNetworkRules
  defaultAction: 'Allow'
}

param allowBlobPublicAccess bool = true

@description('Specify minimum TLS Version')
@allowed([
  'TLS1_1'
  'TLS1_2'
  'TLS1_3'
]
)
param minimumTlsVersion string = 'TLS1_2'

@allowed([
  'east us'
  'west us'
])
param location string ='west us'

resource str 'Microsoft.Storage/storageAccounts@2023-05-01'  = {
  kind:'StorageV2'
  location:location
  name:storage_account_name
  sku: {
   name: sku_name
   }
   properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: allowBlobPublicAccess
    minimumTlsVersion: minimumTlsVersion
    networkAcls: networkAcls
    
  }
}
output storage_id string = str.id
output storage_allowpublicaccess bool = str.properties.allowBlobPublicAccess
