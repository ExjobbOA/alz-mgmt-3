# alz-mgmt — Azure Landing Zone Configuration Repo

> Maintainers: Oskar Granlöf & Alen Fazlagic  
> GitHub Org: `ExjobbOA`  
> This is the **tenant/config repo** in a dual-repo ALZ Bicep architecture.

## Project Status: Active Development

This platform is a work-in-progress thesis project. The high-level architecture (dual-repo split, Deployment Stacks, OIDC auth, ALZ policy library) is settled. The implementation details — file structure, parameter patterns, workflow steps — are actively evolving.

**Planned changes include:**
- Moving to a centralized parameters file that populates all other `.bicepparam` files, replacing the current per-scope parameter sprawl
- Further workflow consolidation and refactoring

**When working in this codebase:** Trust the architectural patterns described below, but always read the actual code for current details. If something in this doc contradicts what you see in the files, the files win. Check `records.md` in the templates repo for the latest architecture decisions and troubleshooting history.

## Architecture Overview

This platform uses a **two-repo split**:

| Repo | Role | Contains |
|------|------|----------|
| **alz-mgmt** (this repo) | Tenant configuration | `.bicepparam` files, `platform.json`, CI/CD trigger workflows |
| **alz-mgmt-templates** | Engine/templates | Bicep modules, reusable GitHub Actions workflows & composite actions, ALZ policy library |

At CI/CD time, the templates repo is checked out to `./platform/` inside this repo's workspace. All `.bicepparam` files reference templates via relative paths like `../../platform/templates/...`.

## Repo Structure

```
alz-mgmt/
├── bicepconfig.json                          # Linter rules + Microsoft Graph extension
├── config/
│   ├── platform.json                         # Central env vars (subscription IDs, location, MG IDs)
│   ├── globals/
│   │   └── defaults.bicepparam               # (currently empty, for shared defaults)
│   ├── bootstrap/
│   │   └── plumbing.bicepparam               # Bootstrap OIDC identity params (run via Cloud Shell)
│   ├── core/
│   │   ├── governance/
│   │   │   └── mgmt-groups/
│   │   │       ├── int-root.bicepparam       # Intermediate root MG config + policy overrides
│   │   │       ├── decommissioned/main.bicepparam
│   │   │       ├── sandbox/main.bicepparam
│   │   │       ├── landingzones/
│   │   │       │   ├── main.bicepparam
│   │   │       │   ├── main-rbac.bicepparam
│   │   │       │   ├── landingzones-corp/main.bicepparam
│   │   │       │   └── landingzones-online/main.bicepparam
│   │   │       └── platform/
│   │   │           ├── main.bicepparam
│   │   │           ├── main-rbac.bicepparam
│   │   │           ├── platform-connectivity/
│   │   │           │   ├── main.bicepparam
│   │   │           │   └── main-rbac.bicepparam
│   │   │           ├── platform-identity/main.bicepparam
│   │   │           ├── platform-management/main.bicepparam
│   │   │           └── platform-security/main.bicepparam
│   │   └── logging/
│   │       └── main.bicepparam               # Log Analytics, Automation Account, AMA/DCR config
│   └── networking/
│       ├── hubnetworking/main.bicepparam     # Hub VNet config
│       └── virtualwan/main.bicepparam        # Virtual WAN config (alternative topology)
└── .github/
    └── workflows/
        ├── ci.yaml                           # PR → calls ci-template.yaml from templates repo
        └── cd.yaml                           # Manual dispatch → calls cd-template.yaml (selective steps)
```

## Key Configuration: platform.json

This JSON file is loaded by GitHub Actions and exported as environment variables:
- `LOCATION` / `LOCATION_PRIMARY`: `swedencentral`
- `INTERMEDIATE_ROOT_MANAGEMENT_GROUP_ID`: `alz`
- `MANAGEMENT_GROUP_ID`: the tenant root MG GUID
- `SUBSCRIPTION_ID_MANAGEMENT`, `SUBSCRIPTION_ID_CONNECTIVITY`, etc.: platform subscription IDs
- `NETWORK_TYPE`: `none` | `hubnetworking` | `virtualwan`

## How .bicepparam Files Work

Every `.bicepparam` file starts with a `using` declaration pointing to a template in the engine repo:
```bicep
using '../../platform/templates/core/governance/mgmt-groups/int-root/main.bicep'
```
The `../../platform/` prefix maps to the templates repo checkout path in CI.

### Important: Policy Parameter Overrides

The `int-root.bicepparam` file uses `parPolicyAssignmentParameterOverrides` to inject environment-specific values (Log Analytics workspace IDs, email contacts, etc.) into ALZ policy assignments. This is the primary customization mechanism — it overrides default values from the JSON policy library without modifying the templates repo.

## CI/CD Pipeline

### CI (ci.yaml) — runs on PR to main
1. Checks out both repos (this → root, templates → `./platform`)
2. `bicep build` lint on all `.bicep` files
3. What-If validation for every deployment scope (governance MGs, logging, networking)
4. What-If skips scopes where the target MG doesn't exist yet (cold-start safety)

### CD (cd.yaml) — manual workflow_dispatch only
- Each deployment step is a boolean input (all default `false`)
- Steps: governance (per MG level), RBAC, core-logging, networking
- Uses **Azure Deployment Stacks** (not raw deployments)
- Retry logic: up to 10 retries with incremental backoff
- Cleans up old deployments before each run to avoid ARM quota issues

### Deployment Order (dependencies)
1. `governance-int-root` (creates ALZ MG + all policy/role defs)
2. `governance-platform` → `governance-platform-{connectivity,identity,management,security}`
3. `governance-landingzones` → `governance-landingzones-{corp,online}`
4. `governance-sandbox`, `governance-decommissioned`
5. `governance-*-rbac` (cross-MG role assignments)
6. `core-logging` (subscription-scoped: LAW, Automation, AMA/DCR)
7. `networking` (hub VNet or Virtual WAN)

### Authentication
- OIDC via Federated Identity Credentials (no client secrets)
- Two UAMIs: `plan` (Reader at MG root) and `apply` (Owner at MG root)
- GitHub environments: `alz-mgmt-plan` (CI) and `alz-mgmt-apply` (CD)

## Bicep Conventions

- **Parameter format**: `.bicepparam` (not JSON parameter files)
- **Linter config** (`bicepconfig.json`): warnings for unused params/vars, outdated API versions, outdated module versions
- **Extensions**: Microsoft Graph v1 extension enabled
- **Shared type**: `alzCoreType` imported from templates repo defines the MG config object shape
- **Module source**: AVM public registry (`br/public:avm/...`)
- **Deployment scope**: `managementGroup` for governance, `subscription` for logging

## Reference Sources

When working with this repo, verify against official sources — especially for module versions and parameter shapes:

- **AVM Module Index**: https://aka.ms/avm/moduleindex — latest versions for all `br/public:avm/...` modules
- **AVM Bicep Modules (GitHub)**: https://github.com/Azure/bicep-registry-modules/tree/main/avm
- **Bicep Language Docs**: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/
- **Deployment Stacks**: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/deployment-stacks

When writing `.bicepparam` files, always check the template being referenced (`using` path) for current parameter names and types — don't guess from memory.

## Common Tasks

### Adding a new management group child
1. Create `config/core/governance/mgmt-groups/<parent>/<child>/main.bicepparam`
2. Use `using` to point to the matching template in the engine repo
3. Add What-If + deploy steps in both `ci.yaml` and `cd.yaml`

### Overriding a policy assignment parameter
Edit `config/core/governance/mgmt-groups/int-root.bicepparam` and add/modify the key in `parPolicyAssignmentParameterOverrides`.

### Changing the deployment region
Update `LOCATION` and `LOCATION_PRIMARY` in `config/platform.json` and adjust any hardcoded `swedencentral` references in `.bicepparam` files.

## Known Gotchas

1. **Cold-start paradox**: First deployment can't What-If against MGs that don't exist yet. The `bicep-first-deployment-check` action + `skipWhatIfIfTargetMgMissing` handle this.
2. **DDoS ghost reference**: Azure Policy with `Modify` effect can inject deleted DDoS plan IDs into VNet deployments. See `records.md` in the templates repo.
3. **Deployment quota**: ARM has a deployment history limit per scope. The pipeline auto-cleans old deployments before each run.
4. **Eventual consistency**: Entra ID propagation delays can cause transient RBAC failures. Use `@batchSize(1)` and `waitForConsistencyCounter*` params.
5. **Cancel trap**: The retry logic in `bicep-deploy` treats cancellation as a transient failure and retries. To truly stop: cancel the GitHub Runner, don't just cancel the deployment.
