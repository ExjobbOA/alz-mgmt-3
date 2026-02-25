using '../../../../platform/templates/core/governance/mgmt-groups/int-root/main.bicep'

var location          = readEnvironmentVariable('LOCATION_PRIMARY')
var locationSecondary = readEnvironmentVariable('LOCATION_SECONDARY', '')
var enableTelemetry   = bool(readEnvironmentVariable('ENABLE_TELEMETRY', 'true'))
var intRootMgId       = readEnvironmentVariable('INTERMEDIATE_ROOT_MANAGEMENT_GROUP_ID')
var mgRootId          = readEnvironmentVariable('MANAGEMENT_GROUP_ID')
var subIdMgmt         = readEnvironmentVariable('SUBSCRIPTION_ID_MANAGEMENT')
var securityEmail     = readEnvironmentVariable('SECURITY_CONTACT_EMAIL', '')
var rgLogging         = 'rg-alz-logging-${location}'
var lawName           = 'law-alz-${location}'
var lawResourceId     = '/subscriptions/${subIdMgmt}/resourceGroups/${rgLogging}/providers/Microsoft.OperationalInsights/workspaces/${lawName}'

param parLocations = [
  location
  locationSecondary
]
param parEnableTelemetry = enableTelemetry

param intRootConfig = {
  createOrUpdateManagementGroup: true
  managementGroupName: intRootMgId
  managementGroupParentId: mgRootId
  managementGroupDisplayName: 'Azure Landing Zones'
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
  'Deploy-MDFC-Config-H224': {
    parameters: {
      logAnalytics: {
        value: lawResourceId
      }
      emailSecurityContact: {
        value: securityEmail
      }
      ascExportResourceGroupName: {
        value: 'rg-alz-asc-${location}'
      }
      ascExportResourceGroupLocation: {
        value: location
      }
    }
  }
  'Deploy-AzActivity-Log': {
    parameters: {
      logAnalytics: {
        value: lawResourceId
      }
      logsEnabled: {
        value: 'True'
      }
    }
  }
  'Deploy-Diag-LogsCat': {
    parameters: {
      logAnalytics: {
        value: lawResourceId
      }
    }
  }
  'Deploy-SvcHealth-BuiltIn': {
    parameters: {
      resourceGroupLocation: {
        value: location
      }
      actionGroupResources: {
        value: {
          actionGroupEmail: [securityEmail]
          eventHubResourceId: []
          functionResourceId: ''
          functionTriggerUrl: ''
          logicappCallbackUrl: ''
          logicappResourceId: ''
          webhookServiceUri: []
        }
      }
    }
  }
  'Deploy-AzSqlDb-Auditing': {
    parameters: {
      logAnalyticsWorkspaceResourceId: {
        value: lawResourceId
      }
    }
  }
}
