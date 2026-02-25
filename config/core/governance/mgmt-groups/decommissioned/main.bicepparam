using '../../../../../platform/templates/core/governance/mgmt-groups/decommissioned/main.bicep'

var location          = readEnvironmentVariable('LOCATION_PRIMARY')
var locationSecondary = readEnvironmentVariable('LOCATION_SECONDARY', '')
var enableTelemetry   = bool(readEnvironmentVariable('ENABLE_TELEMETRY', 'true'))
var intRootMgId       = readEnvironmentVariable('INTERMEDIATE_ROOT_MANAGEMENT_GROUP_ID')

param parLocations = [
  location
  locationSecondary
]
param parEnableTelemetry = enableTelemetry

param decommissionedConfig = {
  createOrUpdateManagementGroup: true
  managementGroupName: 'decommissioned'
  managementGroupParentId: intRootMgId
  managementGroupIntermediateRootName: intRootMgId
  managementGroupDisplayName: 'Decommissioned'
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

param parPolicyAssignmentParameterOverrides = {}
