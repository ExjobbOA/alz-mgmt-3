using '../../../../../platform/templates/core/governance/mgmt-groups/landingzones/main-rbac.bicep'

var enableTelemetry = bool(readEnvironmentVariable('ENABLE_TELEMETRY', 'true'))

param parLandingZonesManagementGroupName = 'landingzones'
param parPlatformManagementGroupName = 'platform'
param parConnectivityManagementGroupName = 'connectivity'
param parManagementGroupExcludedPolicyAssignments = []
param parEnableTelemetry = enableTelemetry
