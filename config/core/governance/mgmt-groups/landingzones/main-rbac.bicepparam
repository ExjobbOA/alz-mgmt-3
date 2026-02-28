using '../../../../../platform/templates/core/governance/mgmt-groups/landingzones/main-rbac.bicep'

var enableTelemetry = bool(readEnvironmentVariable('ENABLE_TELEMETRY', 'true'))
var platformMode    = readEnvironmentVariable('PLATFORM_MODE', 'full')

param parLandingZonesManagementGroupName = 'landingzones'
param parPlatformManagementGroupName = 'platform'
// In simple mode the connectivity child MG doesn't exist; connectivity policies are assigned
// at the platform MG level instead (via parIncludeSubMgPolicies=true on platform/main.bicep).
param parConnectivityManagementGroupName = platformMode == 'simple' ? 'platform' : 'connectivity'
param parManagementGroupExcludedPolicyAssignments = []
param parEnableTelemetry = enableTelemetry
