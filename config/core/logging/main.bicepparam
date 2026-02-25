using '../../../platform/templates/core/logging/main.bicep'

var location          = readEnvironmentVariable('LOCATION_PRIMARY')
var locationSecondary = readEnvironmentVariable('LOCATION_SECONDARY', '')
var enableTelemetry   = bool(readEnvironmentVariable('ENABLE_TELEMETRY', 'true'))
var rgLogging         = 'rg-alz-logging-${location}'
var lawName           = 'law-alz-${location}'
var uamiName          = 'uami-alz-${location}'
var dcrChangeTracking = 'dcr-alz-changetracking-${location}'
var dcrVmInsights     = 'dcr-alz-vminsights-${location}'
var dcrMdfcSql        = 'dcr-alz-mdfcsql-${location}'

param parLocations = [
  location
  locationSecondary
]
param parGlobalResourceLock = {
  name: 'GlobalResourceLock'
  kind: 'None'
  notes: 'This lock was created by the ALZ Bicep Accelerator.'
}
param parTags = {}
param parEnableTelemetry = enableTelemetry

// Resource Group Parameters
param parMgmtLoggingResourceGroup = rgLogging

// Automation Account Parameters
param parAutomationAccountName = 'aa-alz-${location}'
param parAutomationAccountLocation = location
param parDeployAutomationAccount = false
param parAutomationAccountUseManagedIdentity = true
param parAutomationAccountPublicNetworkAccess = true
param parAutomationAccountSku = 'Basic'

// Log Analytics Workspace Parameters
param parLogAnalyticsWorkspaceName = lawName
param parLogAnalyticsWorkspaceLocation = location
param parLogAnalyticsWorkspaceSku = 'PerGB2018'
param parLogAnalyticsWorkspaceCapacityReservationLevel = 100
param parLogAnalyticsWorkspaceLogRetentionInDays = 365
param parLogAnalyticsWorkspaceDailyQuotaGb = null
param parLogAnalyticsWorkspaceReplication = null
param parLogAnalyticsWorkspaceFeatures = null
param parLogAnalyticsWorkspaceDataExports = null
param parLogAnalyticsWorkspaceDataSources = null
param parLogAnalyticsWorkspaceSolutions = [
  'ChangeTracking'
]

// Data Collection Rule Parameters
param parUserAssignedIdentityName = uamiName
param parDataCollectionRuleVMInsightsName = dcrVmInsights
param parDataCollectionRuleChangeTrackingName = dcrChangeTracking
param parDataCollectionRuleMDFCSQLName = dcrMdfcSql
