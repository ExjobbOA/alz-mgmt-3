// This parameters file is intended to be used from the customer repo where the
// templates repo is checked out to ./platform (as in your GitHub workflows).
using '../../platform/bootstrap/plumbing/main.bicep'

@description('Subscription where the identity RG + UAMIs will be created (e.g. management subscription).')
param bootstrapSubscriptionId = '<BOOTSTRAP_SUBSCRIPTION_ID>'

@description('Region for identity resources.')
param location = 'swedencentral'

@description('GitHub org.')
param githubOrg = 'ExjobbOA'

@description('Customer/config repo name (THIS repo name in GitHub). Change if your customer repo is renamed.')
param moduleRepo = 'alz-mgmt'

@description('Templates/engine repo name (where reusable workflows live).')
param templatesRepo = 'alz-mgmt-templates'

@description('GitHub Environment names (must match exactly).')
param envPlan = 'alz-mgmt-plan'
param envApply = 'alz-mgmt-apply'

@description('Branch ref used in job_workflow_ref subject.')
param workflowRefBranch = 'refs/heads/main'

// Optional overrides (leave empty to use derived naming from main.bicep)
param identityRgName = ''
param uamiPlanName = ''
param uamiApplyName = ''
