using '../../../../../platform/templates/core/governance/mgmt-groups/int-root/precreate-alz/main.bicep'

param managementGroupName = 'alz'
param managementGroupDisplayName = 'Azure Landing Zones'

// Parent MG som alz ska ligga under.
// Detta ska vara samma som ni redan använder i int-root.bicepparam
param managementGroupParentId = '3aadcd6c-3c4c-49bc-a9d5-57b7fbf31db7'
