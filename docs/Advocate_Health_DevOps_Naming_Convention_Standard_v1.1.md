**ADVOCATE HEALTH**

**DevOps Naming Convention Standard**

Azure Landing Zone, Multi-Tenant Governance, Infrastructure as Code, Policy as Code, and DevOps



| **Document Field** | **Value** |

| --- | --- |

| Customer | Advocate Health |

| Workstream | DevOps and Platform Automation / Azure Landing Zone |

| Document Type | Enterprise Governance Standard |

| Status | Customer Review Draft |

| Version | 1.1 |

| Prepared By | Microsoft Delivery Team |

| Date | 7 September 2026 |

| Classification | Microsoft Confidential |



|  | Governing intent  Support multiple organizations and tenants through a configurable organization code as the first naming segment, while preserving Advocate Health cloud/environment identifiers and legacy compatibility. |

| --- | --- |





# Document Control

## Revision History

| **Version** | **Date** | **Author / Owner** | **Change** |

| --- | --- | --- | --- |

| 0.1 | 7 Sep 2026 | Microsoft Delivery Team | Initial consolidated draft based on Advocate Health enterprise standards and Microsoft guidance. |

| 1.0 | TBD | Advocate Health Cloud / CCoE | Baseline customer review draft. |

| 1.1 | 7 Sep 2026 | Microsoft Delivery Team | Added configurable <org> as mandatory Segment 1 for multi-organization and multi-tenant use; updated patterns, examples, DevOps, IaC, policy and validation requirements. |



## Review and Approval

| **Approval Area** | **Required Approver** | **Decision** | **Status** |

| --- | --- | --- | --- |

| Organization code and cloud naming | Cloud / CCoE Lead | Approve <org> registry, token catalog and exception process. | Pending |

| Landing Zone architecture | Customer Architecture Authority | Approve management group, subscription, platform and workload patterns. | Pending |

| DevOps and automation | DevOps / Platform Engineering Lead | Approve repositories, pipelines, IaC and validation standards. | Pending |

| Security and identity | Security / IAM Lead | Approve identity, RBAC and policy patterns. | Pending |

| FinOps and metadata | FinOps / Billing Lead | Approve mandatory tag schema and controlled values. | Pending |



## Contents

| **Section** | **Section** |

| --- | --- |

| 1. Executive Summary | 10. Infrastructure-as-Code Standards |

| 2. Purpose, Scope and Authority | 11. Tagging and Metadata Standard |

| 3. Source Analysis and Design Decisions | 12. Enforcement and Compliance |

| 4. Naming Principles | 13. Exceptions and Legacy Resources |

| 5. Enterprise Token Catalog | 14. Implementation and Adoption |

| 6. Canonical Naming Patterns | Appendix A. Abbreviation Catalog |

| 7. Azure Landing Zone Governance Assets | Appendix B. Examples and Validation Checklist |

| 8. Platform Resource Naming Matrix | Appendix C. References |

| 9. DevOps Asset Naming Standards |  |





# 1. Executive Summary

This standard establishes one machine-readable naming and metadata framework for Advocate Health Azure Landing Zone and DevOps work across multiple organizations and tenants. The configurable Organization / Company Code, represented by the literal placeholder <org>, is the first segment of every applicable new name. The approved code for the different Advocate Health Tenants remains TBD and must be confirmed through governance before production adoption.

The standard preserves the Advocate Health defined cloud/environment identifiers: azp (Azure Production), azn (Azure Development/Test), azi (Azure Shared Services), and azx (Azure Sandbox). The naming sequence is <org>, resource type, workload or platform function, Azure region, environment, and instance sequence.

|  | For new resources, <org> MUST be Segment 1 wherever the target service supports it. If a service controls the name, requires a GUID, or has strict length limits, use an approved and documented exception instead of forcing an invalid name. |

| --- | --- |



## 1.1 Standard at a Glance

| **Asset Class** | **Canonical Pattern** | **Example** |

| --- | --- | --- |

| Azure resource | <org>-<resourcetype>-<workload>-<region>-<cloudenv>-<nn> | <org>-vnet-connect-eus2-azp-01 |

| Constrained Azure resource | <org><resourcetype><workload><region><cloudenv><nn> | <org>sttfstateeus2azp01 |

| Resource group | <org>-<resourcetype>-<workload>-<purpose>-<region>-<cloudenv>-<nn> | <org>-rg-platform-connect-eus2-azp-01 |

| Management group | <org>-<function> | <org>-mg-platform |

| Subscription | <org>-sub-<function-or-workload>-<environment>-<nn> | <org>-sub-connectivity-prod-01 |

| Repository | <org>-<domain>-<purpose> | <org>-repo-platform-connectivity |

| Pipeline / workflow | <org>-<domain>-<action>-<env> | <org>-wf-connectivity-deploy-prod |

| Terraform state key | <org>/<layer>/<env>/<region>.tfstate | <org>/connectivity/prod/eus2.tfstate |



## 1.2 Priority of Authority

Azure Resource Manager and service-specific naming rules take precedence over enterprise patterns.

The centrally approved organization code registry governs the value substituted for <org>.

Advocate Health enterprise codes govern cloud/environment, application, workload, and mandatory metadata semantics.

This document governs new Landing Zone and DevOps assets and is the naming contract for automation.

Microsoft Cloud Adoption Framework abbreviation guidance applies when no conflicting enterprise abbreviation exists.

An approved exception record governs any intentional deviation.

# 2. Purpose, Scope and Authority

## 2.1 Purpose

The purpose of this standard is to make resource identification consistent across organizations, tenants, portals, APIs, pipelines, policy checks, Terraform plans, audit evidence, and operational support. It is a governance standard, not merely a style guide.

## 2.2 In Scope

Organization and tenant code governance.

Azure management groups, subscriptions, resource groups, and platform/workload resources.

Management, connectivity, identity, security operations, shared services, subscription vending, sandbox, and decommissioned scopes.

Azure Policy definitions, initiatives, assignments, exemptions, and Policy-as-Code artifacts.

RBAC groups, managed identities, app registrations, service principals, and federated credentials.

Azure DevOps and GitHub projects, repositories, branches, pull requests, pipelines, environments, variable groups, service connections, agent pools, artifacts, and release tags.

Terraform, Bicep, reusable modules, deployment roots, state backends, state keys, parameters, and generated names.

Mandatory Azure tags and governance metadata.

## 2.3 Out of Scope

Renaming existing production resources solely for cosmetic alignment.

Application-internal database objects or data models unless separately approved.

Provider-defined DNS zone names and fixed system child-resource names.

Personal, sensitive, clinical, credential, secret, or confidential information in names or tags.

## 2.4 Normative Language

| **Term** | **Meaning** |

| --- | --- |

| MUST / MUST NOT | Mandatory requirement. |

| SHOULD / SHOULD NOT | Recommended; deviation requires documented rationale. |

| MAY | Optional within stated constraints. |

| LEGACY-ACCEPTED | Existing pattern remains supported but is not the default for new assets. |

| SERVICE-EXCEPTION | Provider rule prevents the canonical token pattern; a documented alternate pattern applies. |



# 3. Source Analysis and Design Decisions

## 3.1 Advocate Health Standard Preserved

The authoritative Advocate Health reference defines A<Cloud><Environment>-<Application>-<O/S or Service>-<number>. It maps Z to Azure; P to Production; N to Development/Test; I to Shared Services; X to Sandbox; and reserves DR and C for future Disaster Recovery and PCI use. It defines three-to-five-character application abbreviations for IaaS, up to ten characters for PaaS, MS/LX operating-system tokens, and a preferred two-digit sequence. Existing resource-group examples end with RG, and the minimum tags are Application, Cost Center, and Department.

## 3.2 Advocate Health and Microsoft-Aligned Governance Structure

The future-state structure extends the authoritative Advocate Health convention with standardized segmentation, organization and tenant context, resource-type abbreviations, region codes, service-specific exceptions, tagging governance, Azure Policy controls, and automation validation. These extensions are written as Advocate Health enterprise requirements and are aligned with Microsoft Cloud Adoption Framework and Azure service constraints.

## 3.3 Multi-Organization Design Direction

The naming standard must remain reusable when assets from multiple companies or tenant consolidation scopes are viewed together. Therefore, <org> is a stable namespace and Segment 1. The actual code value is not defined in this document; it is selected from a controlled registry after formal approval.

## 3.4 Design Decisions

| **Decision** | **Standard** |

| --- | --- |

| Organization prefix | <org> is mandatory Segment 1 wherever technically supported; approved value remains TBD. |

| Cloud/environment | Retain azp/azn/azi/azx semantics as environment values, but place the environment segment after the Azure region. |

| Token order | Organization, resource type, workload or platform function, Azure region, environment, instance sequence. |

| Casing | Lowercase for machine-generated Azure names, code, paths, repositories, and pipeline identifiers. |

| Delimiters | Use a single hyphen where supported; concatenate for constrained services. |

| Legacy IaaS | Existing <cloudenv>-<app>-<os>-<nn> is LEGACY-ACCEPTED. |

| Mutable metadata | Owner, department, cost center, compliance, lifecycle, and support details belong in tags. |

| Automation | A central naming module and controlled registries generate and validate names before deployment. |



# 4. Naming Principles

| **Principle** | **Requirement** |

| --- | --- |

| Organization-first | The approved organization/company/tenant code is the first segment for all applicable assets. |

| Stable | Names contain only attributes expected to remain constant. |

| Deterministic | The same approved inputs always produce the same name. |

| Unique at required scope | Global, tenant, subscription, resource-group, project, repository, or parent scope is validated. |

| Human and machine readable | Operators can understand purpose and automation can parse tokens. |

| Short but meaningful | Approved abbreviations replace ad hoc truncation. |

| Resource-aware | Every resource type is validated against service length and character restrictions. |

| Metadata-light | Names identify; tags describe ownership, finance, compliance, and lifecycle. |

| No sensitive data | Names and tags exclude personal, patient, employee, credential, secret, and confidential data. |

| Automated by default | Pipelines calculate and validate production names. |

| Exception-controlled | Deviations are owned, approved, recorded, reviewed, and time-bound. |



# 5. Enterprise Token Catalog

## 5.1 Organization / Company Code

| **Token** | **Meaning** | **Rule** | **Status** |

| --- | --- | --- | --- |

| <org> | Organization, company, or tenant namespace | Mandatory Segment 1 for applicable names. Substitute only an approved registry value. | TBD / approval required |



The organization code MUST be short, unique across participating organizations, stable over time, lowercase for machine-generated names, and free of business-unit or legal-entity detail likely to change. The code MUST NOT be inferred or invented by delivery teams. The Advocate Health value remains TBD until formally approved.

## 5.2 Cloud and Environment Prefix

| **Code** | **Meaning** | **Use** | **Status** |

| --- | --- | --- | --- |

| azp | Azure Production | Production platform and workload assets. | Approved |

| azn | Azure Development/Test | Non-production development and test assets. | Approved |

| azi | Azure Shared Services | Shared/platform services where environment-neutral. | Approved |

| azx | Azure Sandbox | Time-bound experimentation and sandbox assets. | Approved |

| azdr | Azure Disaster Recovery | Use only after token activation. | Reserved |

| azc | Azure PCI | Use only after compliance approval. | Reserved |



|  | Environment rule  Do not introduce dev, tst, qa, uat, npr, pro, or prod as competing Azure resource prefixes. DevOps environment labels may use prod, nonprod, shared, or sandbox when mapped explicitly to azp, azn, azi, or azx. |

| --- | --- |



## 5.3 Platform and Workload Context

| **Token** | **Meaning** | **Typical Use** |

| --- | --- | --- |

| platform | Enterprise platform scope | Root platform resources |

| management | Operations and monitoring | Management subscription and Log Analytics |

| connect | Connectivity and network hub | Hub VNet, firewall, DNS, ExpressRoute |

| identity | Identity shared services | Identity subscription and services |

| secops | Security operations | Security tooling and integrations |

| shared | Common shared services | Cross-workload capability |

| vending | Subscription vending | Subscription automation and bootstrap |

| clinical | Clinical systems | Approved workload category |

| entapp | Enterprise applications | Approved workload category |

| data | Data and analytics | Approved workload category |

| research | Research | Approved workload category |

| collab | Collaboration services | Approved workload category |

| sandbox | Sandbox services | Experimentation |

| decom | Decommissioned scope | Retired subscriptions/resources |



## 5.4 Region Codes

| **Azure Region** | **Code** | **Azure Region** | **Code** |

| --- | --- | --- | --- |

| East US | eus | East US 2 | eus2 |

| Central US | cus | North Central US | ncus |

| South Central US | scus | West Central US | wcus |

| West US | wus | West US 2 | wus2 |

| West US 3 | wus3 | Global / non-regional | glb |



## 5.5 Instance and Uniqueness

Use two digits (01, 02) as the enterprise default.

Use three digits only where expected fleet size or an approved existing pattern requires it.

Instance numbers distinguish otherwise identical resources; they do not encode priority.

For globally unique services, append a deterministic short suffix only when approved tokens do not guarantee uniqueness.

Validate the combined length after substituting the approved value for <org>.

## 5.6 Token Governance

Organization, application, workload, purpose, and region codes are maintained in controlled registries with full name, code, owner, status, effective date, and retirement state. Ad hoc codes are prohibited in production IaC.

# 6. Canonical Naming Patterns

## 6.1 Default Azure Resource Pattern

<org>-<resource-type>-<workload-or-function>-<region>-<cloudenv>-<instance>Example: <org>-vnet-connect-eus2-azp-01

## 6.2 Extended Pattern

<org>-<resource-type>-<workload>-<purpose>-<region>-<cloudenv>-<instance>Example: <org>-snet-connect-firewall-eus2-azp-01

Use the extended pattern only when purpose is required to distinguish assets of the same type.

## 6.3 Constrained Pattern

<org><resource-type><workload><purpose><region><cloudenv><instance>Example: <org>sttfstateeus2azp01

Remove separators only when the service prohibits them. Apply approved shortening before truncation. The deployed value substitutes the approved code for <org>; angle brackets are documentation notation only.

## 6.4 Legacy VM Pattern

<cloudenv>-<application>-<os>-<instance>Legacy examples: azp-crbl-lx-01 and azn-spkl-lx-01

This pattern remains LEGACY-ACCEPTED. New VM resource and host names SHOULD include <org> when the platform-specific host-length constraint can be met. If it cannot, record a SERVICE-EXCEPTION and retain organization identity in subscription, resource group, tags, and inventory.

## 6.5 Resource Group Pattern

<org>-rg-<workload-or-platform>-<purpose>-<region>-<cloudenv>-<instance>Example: <org>-rg-platform-connect-eus2-azp-01

## 6.6 Token Removal Order for Length Limits

Shorten workload to its approved abbreviation.

Shorten purpose to its approved code.

Use the approved short region code.

Reduce sequence width only when allowed.

Omit region only for genuinely global/non-regional assets.

Use a documented service exception before removing <org>, cloud/environment, or resource type.

## 6.7 Fixed and Provider-Defined Exceptions

| **Asset** | **Exception Treatment** |

| --- | --- |

| Private DNS zone | Use the Azure service zone name; do not prepend <org>. |

| Role assignment / role definition resource name | Use the required GUID; put <org> in the human display name, source artifact, and metadata. |

| System child resources named default/current | Use provider-required value. |

| Management group technical identifier | May use <org>-<function> when valid; otherwise retain <org> in the display name and registry. |

| Windows VM host name | Apply the 15-character host constraint; document any omission of <org>. |



# 7. Azure Landing Zone Governance Assets

## 7.1 Management Groups

| **Level** | **Pattern** | **Example** |

| --- | --- | --- |

| Intermediate root | <org> | <org> |

| Platform | <org>-platform | <org>-platform |

| Platform child | <org>-<platform-function> | <org>-connectivity |

| Workloads | <org>-workloads | <org>-workloads |

| Environment | <org>-workloads-<environment> | <org>-workloads-production |

| Workload category | <org>-<environment>-<category> | <org>-production-clinical |

| Consolidation | <org>-consolidation-<source> | <org>-consolidation-source1 |

| Sandbox | <org>-sandbox | <org>-sandbox |

| Decommissioned | <org>-decommissioned | <org>-decommissioned |

| Policy smoke test | <org>-policy-test | <org>-policy-test |



## 7.2 Subscriptions

<org>-sub-<function-or-workload>-<environment>-<nn>

| **Purpose** | **Example** |

| --- | --- |

| Connectivity | <org>-sub-connectivity-prod-01 |

| Management | <org>-sub-management-prod-01 |

| Identity | <org>-sub-identity-prod-01 |

| Security Operations | <org>-sub-secops-prod-01 |

| Workload production | <org>-sub-clinical-prod-01 |

| Workload non-production | <org>-sub-clinical-nonprod-01 |

| Sandbox | <org>-sub-sandbox-sbx-01 |



## 7.3 Governance Resource Patterns

| **Asset** | **Pattern** | **Example / Note** |

| --- | --- | --- |

| Policy definition | <org>-pol-<category>-<control> | <org>-pol-tags-require-costcenter |

| Policy initiative | <org>-set-<domain>-<baseline> | <org>-set-platform-governance |

| Policy assignment | <org>-pa-<baseline>-<scope> | <org>-pa-platform-baseline |

| Policy exemption | <org>-pex-<control>-<scope>-<ticket> | <org>-pex-publicip-connect-chg12345 |

| Resource lock | <org>-lock-<level>-<purpose> | <org>-lock-cannotdelete-platform |

| Budget | <org>-budget-<scope>-<period> | <org>-budget-connectivity-monthly |

| Custom role display name | <org>-role-<domain>-<permission> | <org>-role-network-readonly |

| Role assignment resource name | GUID | Provider-required GUID; organization retained in source and metadata. |



## 7.4 RBAC and Identity

| **Construct** | **Pattern** | **Example** |

| --- | --- | --- |

| Entra security group | <org>-sg-az-<scope>-<role>-<env> | <org>-sg-az-connect-contributor-prod |

| App registration | <org>-appreg-<platform>-<purpose>-<env>-<nn> | <org>-appreg-ado-platform-prod-01 |

| Service principal display name | <org>-spn-<platform>-<purpose>-<env>-<nn> | <org>-spn-ado-platform-prod-01 |

| User-assigned managed identity | <org>-id-<workload>-<purpose>-<region>-<cloudenv>-<nn> | <org>-id-vending-deploy-eus2-azp-01 |

| Federated credential | <org>-fic-<repo>-<env>-<subject> | <org>-fic-platform-connect-prod-env |

| Emergency identity | <org>-breakglass-<scope>-<nn> | <org>-breakglass-platform-01 |



# 8. Platform Resource Naming Matrix

| **Resource** | **Abbr.** | **Pattern** | **Example** | **Constraint / Note** |

| --- | --- | --- | --- | --- |

| Management group | mg | <org>-<function> | <org>-platform | Tenant scope; stable technical ID. |

| Resource group | rg | <org>-<workload>-<purpose>-<region>-<cloudenv>-rg | <org>-platform-connect-eus2-azp-rg | Lowercase for new IaC. |

| Virtual network | vnet | <org>-vnet-<function>-<region>-<cloudenv>-<nn> | <org>-vnet-connect-eus2-azp-01 | Validate 2-64 characters. |

| Subnet | snet | <org>-snet-<function>-<purpose>-<region>-<cloudenv>-<nn> | <org>-snet-connect-firewall-eus2-azp-01 | Parent scoped. |

| Network security group | nsg | <org>-nsg-<function>-<purpose>-<region>-<cloudenv>-<nn> | <org>-nsg-connect-bastion-eus2-azp-01 | Validate length. |

| Route table | rt | <org>-rt-<function>-<region>-<cloudenv>-<nn> | <org>-rt-connect-eus2-azp-01 | Validate length. |

| Azure Firewall | afw | <org>-afw-<function>-<region>-<cloudenv>-<nn> | <org>-afw-connect-eus2-azp-01 | Validate length. |

| Firewall policy | afwp | <org>-afwp-<function>-<region>-<cloudenv>-<nn> | <org>-afwp-connect-eus2-azp-01 | Validate length. |

| Public IP | pip | <org>-pip-<purpose>-<region>-<cloudenv>-<nn> | <org>-pip-firewall-eus2-azp-01 | Validate length. |

| Private endpoint | pep | <org>-pep-<target>-<region>-<cloudenv>-<nn> | <org>-pep-kv-eus2-azp-01 | Validate 2-64 characters. |

| Private DNS zone | DNS | Azure service zone name | privatelink.vaultcore.azure.net | SERVICE-EXCEPTION: provider-defined zone. |

| Private DNS VNet link | link | <org>-link-<zone>-<vnet>-<nn> | <org>-link-kv-connect-01 | Unique within zone. |

| DNS private resolver | dnspr | <org>-dnspr-<function>-<region>-<cloudenv>-<nn> | <org>-dnspr-connect-eus2-azp-01 | Validate length. |

| ExpressRoute circuit | erc | <org>-erc-<site>-<region>-<cloudenv>-<nn> | <org>-erc-dc1-eus2-azp-01 | Validate length. |

| Key Vault | kv | <org>-kv-<workload>-<region>-<cloudenv>-<nn> | <org>-kv-platform-eus2-azp-01 | 3-24; globally unique. |

| Managed identity | id | <org>-id-<purpose>-<region>-<cloudenv>-<nn> | <org>-id-policy-eus2-azp-01 | 3-128. |

| Storage account | st | <org>st<purpose><region><cloudenv><nn> | <org>sttfstateeus2azp01 | 3-24; lowercase/digits; global. |

| Log Analytics workspace | log | <org>-log-<function>-<region>-<cloudenv>-<nn> | <org>-log-management-eus2-azp-01 | 4-63. |

| Application Insights | appi | <org>-appi-<workload>-<region>-<cloudenv>-<nn> | <org>-appi-vending-eus2-azp-01 | Resource-group scope. |

| Action group | ag | <org>-ag-<purpose>-<region>-<cloudenv>-<nn> | <org>-ag-platformops-eus2-azp-01 | Avoid restricted characters. |

| Data collection rule | dcr | <org>-dcr-<purpose>-<region>-<cloudenv>-<nn> | <org>-dcr-platform-eus2-azp-01 | Resource-group scope. |

| Automation account | aa | <org>-aa-<purpose>-<region>-<cloudenv>-<nn> | <org>-aa-platform-eus2-azp-01 | 6-50. |

| Recovery Services vault | rsv | <org>-rsv-<purpose>-<region>-<cloudenv>-<nn> | <org>-rsv-platform-eus2-azp-01 | 2-50. |

| Backup vault | bvault | <org>-bvault-<purpose>-<region>-<cloudenv>-<nn> | <org>-bvault-platform-eus2-azp-01 | 2-50. |

| Azure Bastion | bas | <org>-bas-<function>-<region>-<cloudenv>-<nn> | <org>-bas-connect-eus2-azp-01 | Validate length. |

| Managed DevOps Pool | mdp | <org>-mdp-<purpose>-<region>-<cloudenv>-<nn> | <org>-mdp-platform-eus2-azp-01 | Use current service rules. |



|  | Implementation requirement  The literal <org> is documentation notation. Automation substitutes the approved lowercase organization code and validates the complete result against the current provider rule before deployment. |

| --- | --- |



# 9. DevOps Asset Naming Standards

## 9.1 Cross-Platform Rules

Use lowercase kebab-case for human-facing projects, repositories, pipeline display names, workflow files, folders, environments, service connections, agent pools, and artifacts unless the platform requires another syntax.

Use snake_case for Terraform symbols and Azure Pipeline stage/job IDs.

Use UPPER_SNAKE_CASE for configuration variables and secret names.

Use <org> as Segment 1 for organization-scoped DevOps assets.

Do not repeat environment in a repository name when the same code is promoted through environments; use protected environments or configuration.

Use main as the protected integration branch.

Validate names programmatically and reject disallowed/reserved characters before API creation.

## 9.2 Organization, Project and Repository

| **Asset** | **Pattern** | **Example** | **Notes** |

| --- | --- | --- | --- |

| GitHub/Azure DevOps organization | <org>-<scope> | <org>-cloud | Approved code substituted at creation. |

| Project | <org>-<domain> | <org>-platform | Stable and broad. |

| Platform repository | <org>-platform-<layer> | <org>-platform-connectivity | Layers include management, connectivity, identity, secops. |

| Landing-zone repository | <org>-landingzone-<purpose> | <org>-landingzone-vending | Subscription vending and bootstrap. |

| Shared workflow repository | <org>-platform-workflows | <org>-platform-workflows | Centrally managed templates. |

| Policy-as-Code repository | <org>-policy-as-code | <org>-policy-as-code | Azure Policy source. |

| Terraform module repository | <org>-terraform-azurerm-<resource> | <org>-terraform-azurerm-key-vault | Internal module. |

| Bicep module repository | <org>-bicep-<domain>-<resource> | <org>-bicep-network-vnet | Internal module. |

| Documentation folder | docs | docs | Repository-local fixed folder; <org> already in repository. |



## 9.3 Branches, Commits and Pull Requests

| **Asset** | **Pattern** | **Example** |

| --- | --- | --- |

| Feature branch | <org>/feature/<workitem>-<slug> | <org>/feature/4312-add-key-vault |

| Bug-fix branch | <org>/bugfix/<workitem>-<slug> | <org>/bugfix/4380-storage-name |

| Hotfix branch | <org>/hotfix/<workitem>-<slug> | <org>/hotfix/4421-policy-assignment |

| Release branch | <org>/release/<major>.<minor> | <org>/release/1.4 |

| Pull request title | <org>: <type>(<scope>): <summary> | <org>: feat(connectivity): add DNS resolver |

| Commit message | <org>: <type>(<scope>): <summary> | <org>: fix(naming): validate storage length |

| Release tag | <org>-v<major>.<minor>.<patch> | <org>-v1.4.2 |



## 9.4 Pipelines, Environments and Connections

| **Asset** | **Pattern** | **Example** |

| --- | --- | --- |

| Pipeline/workflow file | <org>-<domain>-<action>.yml | <org>-terraform-plan.yml |

| Pipeline display name | <org>-<domain>-<action>-<env> | <org>-connectivity-deploy-prod |

| Azure Pipeline stage ID | <org>_<environment>_<action> | <org>_prod_apply |

| Job ID | <org>_<tool>_<action> | <org>_terraform_plan |

| Deployment environment | <org>-<environment> | <org>-prod |

| Variable group | <org>-vg-<domain>-<env> | <org>-vg-connectivity-prod |

| Service connection | <org>-sc-az-<scope>-<env>-<purpose> | <org>-sc-az-connect-prod-apply |

| Agent pool | <org>-pool-<scope>-<os>-<purpose> | <org>-pool-platform-linux-terraform |

| Artifact | <org>-<domain>-<type>-<version> | <org>-connectivity-plan-1.4.2 |



## 9.5 Configuration Variables and Secrets

| **Class** | **Pattern** | **Examples** |

| --- | --- | --- |

| Naming inputs | UPPER_SNAKE_CASE | ORG_CODE, CLOUD_ENV_CODE, WORKLOAD_CODE, AZURE_REGION_CODE, INSTANCE_NUMBER |

| Azure context | UPPER_SNAKE_CASE | AZURE_TENANT_ID, AZURE_SUBSCRIPTION_ID, AZURE_LOCATION |

| Terraform backend | UPPER_SNAKE_CASE | TFSTATE_RESOURCE_GROUP, TFSTATE_STORAGE_ACCOUNT, TFSTATE_CONTAINER, TFSTATE_KEY |

| Secrets | UPPER_SNAKE_CASE | AZURE_CLIENT_ID; use environment scope and federated identity where possible |



# 10. Infrastructure-as-Code Standards

## 10.1 Repository Structure

modules/  platform/{connectivity,management,identity,secops}/  landing-zone/{subscription-vending,shared-services}/deployments/  <org>/platform/<layer>/<environment>/  <org>/landing-zone/<purpose>/<environment>/pipelines/docs/naming-standard.md

## 10.2 Terraform Naming

| **Object** | **Pattern** | **Example** |

| --- | --- | --- |

| Organization root folder | <org> | <org> |

| Root module folder | <org>/<layer>/<environment> | <org>/connectivity/prod |

| Module local name | snake_case | private_dns_resolver |

| Organization variable | org_code | org_code |

| Other variable | snake_case | cloud_env_code |

| Output | snake_case | hub_virtual_network_id |

| Resource symbolic name | snake_case | platform_hub |

| Module source folder | kebab-case | modules/private-dns-resolver |

| tfvars file | <org>.<environment>.<region>.tfvars | <org>.prod.eus2.tfvars |

| State container | <org>-tfstate | <org>-tfstate |

| State key | <org>/<layer>/<env>/<region>.tfstate | <org>/connectivity/prod/eus2.tfstate |

| Plan artifact | <org>-<layer>-<env>-tfplan | <org>-connectivity-prod-tfplan |



## 10.3 Bicep Naming

| **Object** | **Pattern** | **Example** |

| --- | --- | --- |

| Organization parameter | orgCode | orgCode |

| Module file | <resource-or-purpose>.bicep | private-endpoint.bicep |

| Parameter file | <org>.<environment>.<region>.bicepparam | <org>.prod.eus2.bicepparam |

| Symbolic name | camelCase | platformHubVnet |

| Module symbolic name | camelCase | privateDnsResolver |

| Output | camelCase | hubVirtualNetworkId |



## 10.4 Central Naming Contract

All Terraform and Bicep deployment roots MUST call a central naming implementation. The implementation accepts ORG_CODE / org_code / orgCode as a required controlled input, validates it against the organization registry, places it first, returns resource-specific names, and applies service exceptions before plan or deployment. Reusable modules receive the generated name as an input.

## 10.5 Validation Contract

Approved organization code and Segment 1 placement.

Approved cloud/environment code.

Registered workload or platform-function code.

Approved resource abbreviation and region code.

Required instance format.

Allowed characters, delimiters, minimum/maximum length, and uniqueness scope.

Deterministic suffix rule for global names.

No sensitive or confidential content.

Name unchanged between pull-request plan and protected apply.

Documented SERVICE-EXCEPTION when <org> cannot be represented.

## 10.6 Terraform Example

locals {  name_tokens = \[    var.org_code,    "vnet",    "connect",    var.region_code,    var.environment_code,    format("%02d", var.instance)  \]  resource_name = join("-", local.name_tokens)}

## 10.7 Bicep Example

@description('Approved organization code from the central registry')param orgCode stringparam regionCode stringparam environmentCode stringparam instance string = '01'var resourceName = '${orgCode}-vnet-connect-${regionCode}-${environmentCode}-${instance}'

# 11. Tagging and Metadata Standard

## 11.1 Tagging Principles

Tags complement names and provide business, financial, operational, security, organization, and lifecycle metadata that can change independently. Organization identity is normally visible in the name; the Organization tag provides reliable cross-tenant reporting and supports service exceptions where <org> cannot appear in the resource name.

## 11.2 Mandatory Tags

| **Tag** | **Definition** | **Example** | **Rule** |

| --- | --- | --- | --- |

| Organization | Approved organization/company name or code | Approved registry value | Required for multi-organization reporting and service exceptions |

| Application | Approved application or platform service | Platform Connectivity | Preserved enterprise minimum |

| CostCenter | Workday 600 cost center plus area where approved | 600-5000 10126 ENTERPRISE ADVANCED ANALYTICS | Preserved enterprise minimum |

| Department | Workday 600 cost center identifier | 600-5000 10126 | Preserved enterprise minimum |

| Environment | Production / NonProduction / Shared / Sandbox | Production | Controlled value |

| BusinessUnit | Owning business unit | Enterprise Cloud | Controlled catalog |

| BusinessOwner | Accountable business role or group | Clinical Platforms | Prefer group/role |

| TechnicalOwner | Accountable technical team | Cloud Platform Engineering | Prefer group/role |

| SupportGroup | Operational support group | Cloud Operations | Required for handoff |

| ServiceId | Enterprise application/service ID | APP-01234 | Authoritative catalog ID |

| Criticality | Tier1 / Tier2 / Tier3 / Tier4 | Tier2 | Controlled value |

| DataClassification | Public / Internal / Confidential / Restricted | Internal | Controlled value |

| Compliance | None or approved framework list | HIPAA | Controlled value |

| Lifecycle | Active / Suspended / Decommissioning / Retired | Active | Controlled value |

| ManagedBy | Terraform / Bicep / ManualException | Terraform | Automation ownership |

| Repository | Source repository name | <org>-platform-connectivity | Traceability |

| BackupTier | None / Standard / Enhanced / Critical | Standard | Where applicable |



## 11.3 Optional Tags

| **Tag** | **Example** | **Use** |

| --- | --- | --- |

| ShutdownSchedule | weekdays-1900-0600 | Non-production optimization |

| ExpirationDate | 2027-03-31 | Sandbox/temporary expiry |

| ChangeReference | CHG12345 | Exception or migration trace |

| RecoveryTier | regional-4h | Recovery classification |

| MigrationWave | wave-03 | Migration tracking |

| ArchitecturePattern | hub-spoke | Approved platform pattern |

| CreatedByPipeline | <org>-connectivity-deploy-prod | Deployment evidence |



## 11.4 Tag Format Rules

Tag keys use PascalCase exactly as cataloged.

Controlled values use approved spelling and casing.

Organization uses an approved registry value, not the literal placeholder.

Do not place email addresses, patient data, employee IDs, secrets, credentials, or free-form confidential data in tags.

Use authoritative sources for CostCenter, Department, ServiceId, and ownership values.

Resource-group tags do not substitute for resource-level tags where reporting or policy requires the resource tag.

# 12. Enforcement and Compliance

## 12.1 Control Layers

| **Layer** | **Control** | **Required Outcome** |

| --- | --- | --- |

| Developer workstation | Pre-commit and formatting checks | Invalid organization codes, tokens, and names are rejected early. |

| Pull request | Naming unit tests, linting, security and policy checks | Plan shows <org>-first names and mandatory tags. |

| Protected deployment | Same naming module and immutable plan artifact | Apply cannot introduce different names. |

| Azure Policy / Policy as Code | Audit or deny where technically reliable; modify/deny required tags | Inherited guardrails are consistent. |

| Resource Graph / reporting | Scheduled compliance query | Compliant, legacy, exception, and noncompliant assets are visible. |

| Exception register | Approved deviation record | Every deviation has owner, reason, expiry, and remediation decision. |



## 12.2 Policy-as-Code Naming

| **Policy Asset** | **Pattern** | **Example** |

| --- | --- | --- |

| Definition file | <org>-pol-<category>-<control>.json | <org>-pol-tags-require-org.json |

| Initiative file | <org>-set-<domain>-<baseline>.json | <org>-set-platform-governance.json |

| Assignment file | <org>-pa-<baseline>-<scope>.json | <org>-pa-platform-baseline.json |

| Exemption file | <org>-pex-<control>-<scope>-<ticket>.json | <org>-pex-location-sandbox-chg12345.json |

| Environment selector | <org>-<stage> | <org>-nonprod / <org>-prod |



## 12.3 Enforcement Rollout

Document and unit-test the organization-first rule in the central naming module.

Validate ORG_CODE against the controlled registry.

Run compliance discovery in audit/report mode.

Classify compliant, legacy-accepted, service-exception, exception-approved, and noncompliant assets.

Remediate new IaC before enabling deny controls.

Promote controls through a policy test scope before broad assignment.

Enable deny only where the rule is technically reliable for the targeted resource types.

## 12.4 Compliance Statuses

| **Status** | **Definition** |

| --- | --- |

| Compliant | Matches the current organization-first standard and required metadata. |

| Legacy-Accepted | Predates the standard and is registered; no immediate rename required. |

| Service-Exception | Provider rule prevents the canonical format; approved alternate pattern and metadata are used. |

| Exception-Approved | Deviation has active approval and expiry/remediation decision. |

| Noncompliant | No approved basis for deviation. |

| Not Applicable | Asset type cannot support the applicable control. |



# 13. Exceptions and Legacy Resources

## 13.1 Legacy Treatment

Existing resources are not renamed solely for cosmetic consistency when replacement could introduce downtime, data movement, identity change, DNS change, or unsupported operational risk. Legacy names are inventoried and mapped to organization, tenant, and current metadata through tags and the configuration repository.

## 13.2 Exception Record

| **Field** | **Required Content** |

| --- | --- |

| Exception ID | Unique governance or change record. |

| Organization Code | Approved organization code associated with the asset. |

| Asset / Resource Type | Affected type and scope. |

| Proposed Name | Exact name to deploy or retain. |

| Violated Rule | Specific pattern or constraint. |

| Technical Reason | Why compliance is impossible or materially unsafe. |

| Risk and Compensating Control | Impact and mitigation, including organization metadata. |

| Owner and Approver | Accountable team and approval authority. |

| Effective and Expiry Dates | Start and review/expiry date. |

| Remediation Decision | Rename, replace, retire, or permanent approved exception. |



## 13.3 New Resource Type Onboarding

Azure provider and resource type.

Resource abbreviation or approved enterprise alternative.

Uniqueness scope, length, characters, casing, and separators.

Ability to represent <org> as Segment 1.

Required and optional tokens.

Canonical and constrained patterns.

Tested compliant example using <org>.

Central naming-module implementation and unit tests.

Governance owner approval.

# 14. Implementation and Adoption

## 14.1 Implementation Phases

| **Phase** | **Activities** | **Exit Criteria** |

| --- | --- | --- |

| 1 - Approve | Approve organization-code policy, registry owner, token catalog, platform scope, resource matrix, and tags. | Approved <org> value remains controlled outside this document. |

| 2 - Implement | Create organization registry, naming module, validation tests, repository documentation, and policy artifacts. | Names are generated consistently in the lab. |

| 3 - Pilot | Apply to connectivity, management, identity, secops, and subscription-vending deployments. | Deployment evidence and exceptions are captured. |

| 4 - Enforce | Enable pipeline gates and staged Policy-as-Code controls. | New deployments cannot bypass approved organization-first naming and tags. |

| 5 - Operate | Publish compliance reports, review exceptions, and maintain registries. | Recurring governance cadence established. |



## 14.2 Ownership Model

| **Role** | **Responsibility** |

| --- | --- |

| Cloud / CCoE naming authority | Own this standard, organization-code registry, controlled vocabulary, and exceptions. |

| Platform Engineering | Implement naming module and service-specific overrides. |

| DevOps Engineering | Implement repository, pipeline, environment, and validation standards. |

| Security / IAM | Approve identity, RBAC, credential, and policy controls. |

| FinOps | Own cost and financial metadata requirements. |

| Workload teams | Use registered organization and workload codes and provide accurate tags. |

| Operations | Validate supportability, monitoring, backup, and lifecycle metadata. |



## 14.3 Definition of Done for a Deployment

The organization code is selected from the approved registry.

All applicable names begin with the approved organization code.

All names are generated from the central naming implementation.

All names pass provider constraints and uniqueness validation.

Required tags, including Organization, are present with controlled values.

Pull request includes plan and validation evidence.

Production deployment uses a protected environment and approved identity.

State key and deployment boundary include organization scope.

Any deviation has an active exception record.

Documentation and catalogs are updated for new resource types.

# Appendix A. Abbreviation Catalog

| **Category** | **Resource / Asset** | **Abbreviation** |

| --- | --- | --- |

| Governance | Management group | mg |

| Governance | Resource group | rg |

| Governance | Policy definition | pol |

| Governance | Policy initiative | set |

| Governance | Policy assignment | pa |

| Governance | Policy exemption | pex |

| Identity | Managed identity | id |

| Identity | Service principal | spn |

| Identity | Application registration | appreg |

| Networking | Virtual network | vnet |

| Networking | Subnet | snet |

| Networking | Network security group | nsg |

| Networking | Route table | rt |

| Networking | Azure Firewall | afw |

| Networking | Firewall policy | afwp |

| Networking | Public IP | pip |

| Networking | Private endpoint | pep |

| Networking | ExpressRoute circuit | erc |

| Networking | Virtual network gateway | vgw |

| Networking | DNS private resolver | dnspr |

| Security | Key Vault | kv |

| Security | Bastion | bas |

| Management | Log Analytics workspace | log |

| Management | Application Insights | appi |

| Management | Action group | ag |

| Management | Data collection rule | dcr |

| Management | Automation account | aa |

| Recovery | Recovery Services vault | rsv |

| Recovery | Backup vault | bvault |

| Storage | Storage account | st |

| Compute | Virtual machine | vm |

| Compute | Virtual machine scale set | vmss |

| Containers | Container registry | cr |

| Containers | AKS cluster | aks |

| DevOps | Managed DevOps Pool | mdp |

| Data | Azure Data Factory | adf |

| Data | Databricks workspace | dbw |

| AI | Azure Machine Learning workspace | mlw |

| AI | Azure OpenAI Service | oai |



# Appendix B. Examples and Validation Checklist

## B.1 Landing Zone Examples

| **Scenario** | **Names** |

| --- | --- |

| Production connectivity hub | Subscription: <org>-sub-connectivity-prod-01RG: <org>-azp-platform-connect-eus2-rgVNet: <org>-azp-vnet-connect-eus2-01Firewall: <org>-azp-afw-connect-eus2-01 |

| Shared management | Subscription: <org>-sub-management-prod-01LAW: <org>-azp-log-management-eus2-01Action group: <org>-azp-ag-platformops-eus2-01 |

| Subscription vending | Repo: <org>-landingzone-vendingIdentity: <org>-azp-id-vending-deploy-eus2-01Workflow: <org>-vending-deploy-prodState: <org>/vending/prod/eus2.tfstate |

| Policy as Code | Repo: <org>-policy-as-codeInitiative: <org>-set-platform-governanceAssignment: <org>-pa-platform-baseline |



## B.2 Pre-Deployment Checklist

☐ Approved organization code selected from the registry.

☐ Approved organization code is Segment 1 for every applicable name.

☐ Correct environment code follows the Azure region segment.

☐ Resource abbreviation exists in the approved catalog.

☐ Workload or platform function is registered.

☐ Region code is approved and applicable.

☐ Sequence is zero-padded.

☐ Final substituted name meets provider length, character, and uniqueness rules.

☐ Constrained-name logic is used only where required.

☐ Organization and other required tags are populated from authoritative sources.

☐ Terraform/Bicep plan uses the same generated name as apply.

☐ No personal, sensitive, or confidential data is present.

☐ Exception record exists for any deviation or service constraint.

# Appendix C. References

| **Source Type** | **Title** | **Location / Use** |

| --- | --- | --- |

| Primary enterprise reference | Advocate_Cloud_Naming_Conventions.docx | Advocate Health cloud/environment codes, examples, VM compatibility, resource-group suffix, and minimum tags. |

| Advocate workstream reference | 06 SE DevOps and Platform Automation Assessment and Recommendations.docx | Terraform, modules, state, identities, pull requests, validation, promotion, and drift direction. |

| Advocate landing-zone reference | SE Landing Zone Assessment and Recommendations_v1.docx | Management-group hierarchy, platform functions, governance, naming, and tagging direction. |

| Microsoft CAF | Define your naming convention | Microsoft Learn: Azure Cloud Adoption Framework resource naming. |

| Microsoft CAF | Azure resource abbreviation recommendations | Microsoft Learn: recommended resource abbreviations. |

| Azure Resource Manager | Naming rules and restrictions | Microsoft Learn: provider-specific length, character, and uniqueness constraints. |

| Microsoft CAF | Define your tagging strategy | Microsoft Learn: Azure tagging guidance. |

| Azure DevOps | Naming restrictions and conventions | Microsoft Learn: Azure DevOps organization, project, repository, pipeline, and artifact restrictions. |

| Azure Policy | Policy assignment structure | Microsoft Learn: policy assignment requirements. |

| Policy as Code | Enterprise Azure Policy as Code | Microsoft-supported open-source policy-as-code approach. |



|  | Maintenance requirement  The organization-code registry, resource abbreviation catalog, and service constraints MUST be reviewed whenever an organization is onboarded, a new resource type is introduced, or Microsoft changes a naming rule. |

| --- | --- |
