using '../../../../../../platform/templates/core/governance/mgmt-groups/platform/platform-connectivity/main-rbac.bicep'

var enableTelemetry = bool(readEnvironmentVariable('ENABLE_TELEMETRY', 'true'))

param parCorpManagementGroupName = 'corp'
param parConnectivityManagementGroupName = 'connectivity'
param parManagementGroupExcludedPolicyAssignments = []
param parEnableTelemetry = enableTelemetry
