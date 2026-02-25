using '../../../../../../platform/templates/core/governance/mgmt-groups/platform/platform-connectivity/main.bicep'

var location          = readEnvironmentVariable('LOCATION_PRIMARY')
var locationSecondary = readEnvironmentVariable('LOCATION_SECONDARY', '')
var enableTelemetry   = bool(readEnvironmentVariable('ENABLE_TELEMETRY', 'true'))
var intRootMgId       = readEnvironmentVariable('INTERMEDIATE_ROOT_MANAGEMENT_GROUP_ID')
var subIdConn         = readEnvironmentVariable('SUBSCRIPTION_ID_CONNECTIVITY')
var rgConn            = 'rg-alz-conn-${location}'
var ddosResourceId    = '/subscriptions/${subIdConn}/resourceGroups/${rgConn}/providers/Microsoft.Network/ddosProtectionPlans/ddos-alz-${location}'

param parLocations = [
  location
  locationSecondary
]
param parEnableTelemetry = enableTelemetry

param platformConnectivityConfig = {
  createOrUpdateManagementGroup: true
  managementGroupName: 'connectivity'
  managementGroupParentId: 'platform'
  managementGroupIntermediateRootName: intRootMgId
  managementGroupDisplayName: 'Connectivity'
  managementGroupDoNotEnforcePolicyAssignments: []
  managementGroupExcludedPolicyAssignments: []
  customerRbacRoleDefs: []
  customerRbacRoleAssignments: []
  customerPolicyDefs: []
  customerPolicySetDefs: []
  customerPolicyAssignments: []
  subscriptionsToPlaceInManagementGroup: [subIdConn]
  waitForConsistencyCounterBeforeCustomPolicyDefinitions: 10
  waitForConsistencyCounterBeforeCustomPolicySetDefinitions: 10
  waitForConsistencyCounterBeforeCustomRoleDefinitions: 10
  waitForConsistencyCounterBeforePolicyAssignments: 40
  waitForConsistencyCounterBeforeRoleAssignments: 40
  waitForConsistencyCounterBeforeSubPlacement: 40
}

param parPolicyAssignmentParameterOverrides = {
  'Enable-DDoS-VNET': {
    parameters: {
      ddosPlan: {
        value: ddosResourceId
      }
    }
  }
}
