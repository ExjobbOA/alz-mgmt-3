using '../../../../../platform/templates/core/governance/mgmt-groups/platform/main-rbac.bicep'

var enableTelemetry = bool(readEnvironmentVariable('ENABLE_TELEMETRY', 'true'))
var platformMode    = readEnvironmentVariable('PLATFORM_MODE', 'full')

param parPlatformManagementGroupName = 'platform'
param parConnectivityManagementGroupName = 'connectivity'
param parCorpManagementGroupName = 'corp'
param parPlatformMode = platformMode
param parManagementGroupExcludedPolicyAssignments = []
param parEnableTelemetry = enableTelemetry
