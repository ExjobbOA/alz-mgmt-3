using '../../../../../platform/templates/core/governance/mgmt-groups/platform/main.bicep'

var location                    = readEnvironmentVariable('LOCATION_PRIMARY')
var locationSecondary           = readEnvironmentVariable('LOCATION_SECONDARY', '')
var enableTelemetry             = bool(readEnvironmentVariable('ENABLE_TELEMETRY', 'true'))
var intRootMgId                 = readEnvironmentVariable('INTERMEDIATE_ROOT_MANAGEMENT_GROUP_ID')
var platformMode                = readEnvironmentVariable('PLATFORM_MODE', 'full')
var subIdMgmt                   = readEnvironmentVariable('SUBSCRIPTION_ID_MANAGEMENT')
var subIdPlatform               = readEnvironmentVariable('SUBSCRIPTION_ID_PLATFORM', '')
var includeSubMgPolicies        = platformMode == 'simple'
var platformSubscriptions       = (platformMode == 'simple' && subIdPlatform != '') ? [subIdPlatform] : []
var rgLogging                   = 'rg-alz-logging-${location}'
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

param parLocations = [
  location
  locationSecondary
]
param parEnableTelemetry = enableTelemetry
param parIncludeSubMgPolicies = includeSubMgPolicies

param platformConfig = {
  createOrUpdateManagementGroup: true
  managementGroupName: 'platform'
  managementGroupParentId: intRootMgId
  managementGroupIntermediateRootName: intRootMgId
  managementGroupDisplayName: 'Platform'
  managementGroupDoNotEnforcePolicyAssignments: []
  managementGroupExcludedPolicyAssignments: []
  customerRbacRoleDefs: []
  customerRbacRoleAssignments: []
  customerPolicyDefs: []
  customerPolicySetDefs: []
  customerPolicyAssignments: []
  subscriptionsToPlaceInManagementGroup: platformSubscriptions
  waitForConsistencyCounterBeforeCustomPolicyDefinitions: 10
  waitForConsistencyCounterBeforeCustomPolicySetDefinitions: 10
  waitForConsistencyCounterBeforeCustomRoleDefinitions: 10
  waitForConsistencyCounterBeforePolicyAssignments: 40
  waitForConsistencyCounterBeforeRoleAssignments: 40
  waitForConsistencyCounterBeforeSubPlacement: 10
}

param parPolicyAssignmentParameterOverrides = {
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
  'Deploy-vmArc-ChangeTrack': {
    parameters: {
      dcrResourceId: {
        value: dcrChangeTrackingResourceId
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
  'DenyAction-DeleteUAMIAMA': {
    parameters: {
      resourceName: {
        value: uamiName
      }
    }
  }
}
