using '../../../../../platform/templates/core/governance/mgmt-groups/landingzones/main.bicep'

var location                    = readEnvironmentVariable('LOCATION_PRIMARY')
var locationSecondary           = readEnvironmentVariable('LOCATION_SECONDARY', '')
var enableTelemetry             = bool(readEnvironmentVariable('ENABLE_TELEMETRY', 'true'))
var intRootMgId                 = readEnvironmentVariable('INTERMEDIATE_ROOT_MANAGEMENT_GROUP_ID')
var subIdMgmt                   = readEnvironmentVariable('SUBSCRIPTION_ID_MANAGEMENT')
var subIdConn                   = readEnvironmentVariable('SUBSCRIPTION_ID_CONNECTIVITY')
var rgLogging                   = 'rg-alz-logging-${location}'
var rgConn                      = 'rg-alz-conn-${location}'
var lawName                     = 'law-alz-${location}'
var uamiName                    = 'uami-alz-${location}'
var dcrChangeTracking           = 'dcr-alz-changetracking-${location}'
var dcrVmInsights               = 'dcr-alz-vminsights-${location}'
var dcrMdfcSql                  = 'dcr-alz-mdfcsql-${location}'
var lawResourceId               = '/subscriptions/${subIdMgmt}/resourceGroups/${rgLogging}/providers/Microsoft.OperationalInsights/workspaces/${lawName}'
var uamiResourceId              = '/subscriptions/${subIdMgmt}/resourceGroups/${rgLogging}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/${uamiName}'
var dcrChangeTrackingResourceId = '/subscriptions/${subIdMgmt}/resourceGroups/${rgLogging}/providers/Microsoft.Insights/dataCollectionRules/${dcrChangeTracking}'
var dcrVmInsightsResourceId     = '/subscriptions/${subIdMgmt}/resourceGroups/${rgLogging}/providers/Microsoft.Insights/dataCollectionRules/${dcrVmInsights}'
var dcrMdfcSqlResourceId        = '/subscriptions/${subIdMgmt}/resourceGroups/${rgLogging}/providers/Microsoft.Insights/dataCollectionRules/${dcrMdfcSql}'
var ddosResourceId              = '/subscriptions/${subIdConn}/resourceGroups/${rgConn}/providers/Microsoft.Network/ddosProtectionPlans/ddos-alz-${location}'

param parLocations = [
  location
  locationSecondary
]
param parEnableTelemetry = enableTelemetry

param landingZonesConfig = {
  createOrUpdateManagementGroup: true
  managementGroupName: 'landingzones'
  managementGroupParentId: intRootMgId
  managementGroupIntermediateRootName: intRootMgId
  managementGroupDisplayName: 'Landing Zones'
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
  'Enable-DDoS-VNET': {
    parameters: {
      ddosPlan: {
        value: ddosResourceId
      }
    }
  }
  'Deploy-AzSqlDb-Auditing': {
    parameters: {
      logAnalyticsWorkspaceId: {
        value: lawResourceId
      }
    }
  }
  'Deploy-vmArc-ChangeTrack': {
    parameters: {
      dcrResourceId: {
        value: dcrChangeTrackingResourceId
      }
    }
  }
  'Deploy-VM-ChangeTrack': {
    parameters: {
      dcrResourceId: {
        value: dcrChangeTrackingResourceId
      }
      userAssignedIdentityResourceId: {
        value: uamiResourceId
      }
    }
  }
  'Deploy-VMSS-ChangeTrack': {
    parameters: {
      dcrResourceId: {
        value: dcrChangeTrackingResourceId
      }
      userAssignedIdentityResourceId: {
        value: uamiResourceId
      }
    }
  }
  'Deploy-vmHybr-Monitoring': {
    parameters: {
      dcrResourceId: {
        value: dcrVmInsightsResourceId
      }
    }
  }
  'Deploy-VM-Monitoring': {
    parameters: {
      dcrResourceId: {
        value: dcrVmInsightsResourceId
      }
      userAssignedIdentityResourceId: {
        value: uamiResourceId
      }
    }
  }
  'Deploy-VMSS-Monitoring': {
    parameters: {
      dcrResourceId: {
        value: dcrVmInsightsResourceId
      }
      userAssignedIdentityResourceId: {
        value: uamiResourceId
      }
    }
  }
  'Deploy-MDFC-DefSQL-AMA': {
    parameters: {
      userWorkspaceResourceId: {
        value: lawResourceId
      }
      dcrResourceId: {
        value: dcrMdfcSqlResourceId
      }
      userAssignedIdentityResourceId: {
        value: uamiResourceId
      }
    }
  }
}
