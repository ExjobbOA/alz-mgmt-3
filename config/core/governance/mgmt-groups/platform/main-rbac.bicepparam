using '../../../../../platform/templates/core/governance/mgmt-groups/platform/main-rbac.bicep'

var enableTelemetry = bool(readEnvironmentVariable('ENABLE_TELEMETRY', 'true'))

param parPlatformManagementGroupName = 'platform'
param parConnectivityManagementGroupName = 'connectivity'
param parManagementGroupExcludedPolicyAssignments = []
param parEnableTelemetry = enableTelemetry
