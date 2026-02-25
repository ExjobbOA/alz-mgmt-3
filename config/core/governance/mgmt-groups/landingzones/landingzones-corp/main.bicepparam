using '../../../../../../platform/templates/core/governance/mgmt-groups/landingzones/landingzones-corp/main.bicep'

var location          = readEnvironmentVariable('LOCATION_PRIMARY')
var locationSecondary = readEnvironmentVariable('LOCATION_SECONDARY', '')
var enableTelemetry   = bool(readEnvironmentVariable('ENABLE_TELEMETRY', 'true'))
var intRootMgId       = readEnvironmentVariable('INTERMEDIATE_ROOT_MANAGEMENT_GROUP_ID')
var subIdConn         = readEnvironmentVariable('SUBSCRIPTION_ID_CONNECTIVITY')
var rgDns             = 'rg-alz-dns-${location}'
var dnsPrefixId       = '/subscriptions/${subIdConn}/resourceGroups/${rgDns}/providers/Microsoft.Network/privateDnsZones/'

param parLocations = [
  location
  locationSecondary
]
param parEnableTelemetry = enableTelemetry

param landingZonesCorpConfig = {
  createOrUpdateManagementGroup: true
  managementGroupName: 'corp'
  managementGroupParentId: 'landingzones'
  managementGroupIntermediateRootName: intRootMgId
  managementGroupDisplayName: 'Corp'
  managementGroupDoNotEnforcePolicyAssignments: []
  managementGroupExcludedPolicyAssignments: []
  customerRbacRoleDefs: []
  customerRbacRoleAssignments: []
  customerPolicyDefs: []
  customerPolicySetDefs: []
  customerPolicyAssignments: []
  subscriptionsToPlaceInManagementGroup: []
  waitForConsistencyCounterBeforeCustomPolicyDefinitions: 10
  waitForConsistencyCounterBeforeCustomPolicySetDefinitions: 10
  waitForConsistencyCounterBeforeCustomRoleDefinitions: 10
  waitForConsistencyCounterBeforePolicyAssignments: 40
  waitForConsistencyCounterBeforeRoleAssignments: 40
  waitForConsistencyCounterBeforeSubPlacement: 10
}

param parPolicyAssignmentParameterOverrides = {
  'Deploy-Private-DNS-Zones': {
    parameters: {
      azureAcrPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.azurecr.io'
      }
      azureAppPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.azurewebsites.net'
      }
      azureAppServicesPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.azurewebsites.net'
      }
      azureArcGuestconfigurationPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.guestconfiguration.azure.com'
      }
      azureArcHybridResourceProviderPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.his.arc.azure.com'
      }
      azureArcKubernetesConfigurationPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.dp.kubernetesconfiguration.azure.com'
      }
      azureAsrPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.siterecovery.windowsazure.com'
      }
      azureAutomationDSCHybridPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.azure-automation.net'
      }
      azureAutomationWebhookPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.azure-automation.net'
      }
      azureBatchPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.batch.azure.com'
      }
      azureBotServicePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.directline.botframework.com'
      }
      azureCognitiveSearchPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.search.windows.net'
      }
      azureCognitiveServicesPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.cognitiveservices.azure.com'
      }
      azureCosmosCassandraPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.cassandra.cosmos.azure.com'
      }
      azureCosmosGremlinPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.gremlin.cosmos.azure.com'
      }
      azureCosmosMongoPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.mongo.cosmos.azure.com'
      }
      azureCosmosSQLPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.documents.azure.com'
      }
      azureCosmosTablePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.table.cosmos.azure.com'
      }
      azureDataFactoryPortalPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.adf.azure.com'
      }
      azureDataFactoryPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.datafactory.azure.net'
      }
      azureDatabricksPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.azuredatabricks.net'
      }
      azureDiskAccessPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.blob.core.windows.net'
      }
      azureEventGridDomainsPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.eventgrid.azure.net'
      }
      azureEventGridTopicsPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.eventgrid.azure.net'
      }
      azureEventHubNamespacePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.servicebus.windows.net'
      }
      azureFilePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.afs.azure.net'
      }
      azureHDInsightPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.azurehdinsight.net'
      }
      azureIotCentralPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.azureiotcentral.com'
      }
      azureIotDeviceupdatePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.api.adu.microsoft.com'
      }
      azureIotHubsPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.azure-devices.net'
      }
      azureIotPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.azure-devices-provisioning.net'
      }
      azureKeyVaultPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.vaultcore.azure.net'
      }
      azureMachineLearningWorkspacePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.api.azureml.ms'
      }
      azureMachineLearningWorkspaceSecondPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.notebooks.azure.net'
      }
      azureManagedGrafanaWorkspacePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.grafana.azure.com'
      }
      azureMediaServicesKeyPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.media.azure.net'
      }
      azureMediaServicesLivePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.media.azure.net'
      }
      azureMediaServicesStreamPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.media.azure.net'
      }
      azureMigratePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.prod.migration.windowsazure.com'
      }
      azureMonitorPrivateDnsZoneId1: {
        value: '${dnsPrefixId}privatelink.monitor.azure.com'
      }
      azureMonitorPrivateDnsZoneId2: {
        value: '${dnsPrefixId}privatelink.oms.opinsights.azure.com'
      }
      azureMonitorPrivateDnsZoneId3: {
        value: '${dnsPrefixId}privatelink.ods.opinsights.azure.com'
      }
      azureMonitorPrivateDnsZoneId4: {
        value: '${dnsPrefixId}privatelink.agentsvc.azure-automation.net'
      }
      azureMonitorPrivateDnsZoneId5: {
        value: '${dnsPrefixId}privatelink.blob.core.windows.net'
      }
      azureRedisCachePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.redis.cache.windows.net'
      }
      azureServiceBusNamespacePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.servicebus.windows.net'
      }
      azureSignalRPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.service.signalr.net'
      }
      azureSiteRecoveryBackupPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.{regionCode}.backup.windowsazure.com'
      }
      azureSiteRecoveryBlobPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.blob.core.windows.net'
      }
      azureSiteRecoveryQueuePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.queue.core.windows.net'
      }
      azureStorageBlobPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.blob.core.windows.net'
      }
      azureStorageBlobSecPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.blob.core.windows.net'
      }
      azureStorageDFSPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.dfs.core.windows.net'
      }
      azureStorageDFSSecPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.dfs.core.windows.net'
      }
      azureStorageFilePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.file.core.windows.net'
      }
      azureStorageQueuePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.queue.core.windows.net'
      }
      azureStorageQueueSecPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.queue.core.windows.net'
      }
      azureStorageStaticWebPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.web.core.windows.net'
      }
      azureStorageStaticWebSecPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.web.core.windows.net'
      }
      azureStorageTablePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.table.core.windows.net'
      }
      azureStorageTableSecondaryPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.table.core.windows.net'
      }
      azureSynapseDevPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.dev.azuresynapse.net'
      }
      azureSynapseSQLPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.sql.azuresynapse.net'
      }
      azureSynapseSQLODPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.sql.azuresynapse.net'
      }
      azureVirtualDesktopHostpoolPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.wvd.microsoft.com'
      }
      azureVirtualDesktopWorkspacePrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.wvd.microsoft.com'
      }
      azureWebPrivateDnsZoneId: {
        value: '${dnsPrefixId}privatelink.azurewebsites.net'
      }
    }
  }

  'Audit-PeDnsZones': {
    parameters: {
      privateLinkDnsZones: {
        value: [
          'privatelink.azurecr.io'
          'privatelink.azurewebsites.net'
          'privatelink.guestconfiguration.azure.com'
          'privatelink.his.arc.azure.com'
          'privatelink.dp.kubernetesconfiguration.azure.com'
          'privatelink.siterecovery.windowsazure.com'
          'privatelink.azure-automation.net'
          'privatelink.batch.azure.com'
          'privatelink.directline.botframework.com'
          'privatelink.search.windows.net'
          'privatelink.cognitiveservices.azure.com'
          'privatelink.cassandra.cosmos.azure.com'
          'privatelink.gremlin.cosmos.azure.com'
          'privatelink.mongo.cosmos.azure.com'
          'privatelink.documents.azure.com'
          'privatelink.table.cosmos.azure.com'
          'privatelink.adf.azure.com'
          'privatelink.datafactory.azure.net'
          'privatelink.azuredatabricks.net'
          'privatelink.eventgrid.azure.net'
          'privatelink.servicebus.windows.net'
          'privatelink.afs.azure.net'
          'privatelink.azurehdinsight.net'
          'privatelink.azureiotcentral.com'
          'privatelink.api.adu.microsoft.com'
          'privatelink.azure-devices.net'
          'privatelink.azure-devices-provisioning.net'
          'privatelink.vaultcore.azure.net'
          'privatelink.api.azureml.ms'
          'privatelink.notebooks.azure.net'
          'privatelink.grafana.azure.com'
          'privatelink.media.azure.net'
          'privatelink.prod.migration.windowsazure.com'
          'privatelink.monitor.azure.com'
          'privatelink.oms.opinsights.azure.com'
          'privatelink.ods.opinsights.azure.com'
          'privatelink.agentsvc.azure-automation.net'
          'privatelink.redis.cache.windows.net'
          'privatelink.service.signalr.net'
          'privatelink.blob.core.windows.net'
          'privatelink.dfs.core.windows.net'
          'privatelink.file.core.windows.net'
          'privatelink.queue.core.windows.net'
          'privatelink.table.core.windows.net'
          'privatelink.web.core.windows.net'
          'privatelink.dev.azuresynapse.net'
          'privatelink.sql.azuresynapse.net'
          'privatelink.wvd.microsoft.com'
        ]
      }
    }
  }
}
