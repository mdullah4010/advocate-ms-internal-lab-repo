# Terraform Module Enhancement Proposal

## Purpose

This proposal describes enhancements to the Terraform modules that improve naming consistency, tagging, security, and deployment governance.

The recommendations support the [Advocate Health DevOps Naming Convention Standard v1.1](Advocate_Health_DevOps_Naming_Convention_Standard_v1.1.md) and the [module development guidelines](../modules/README.md).

> **Important:** The naming standard is currently a customer-review draft, and the approved organization code is still pending. Build and test the capabilities described here, but do not enable strict production enforcement until the naming authority approves the organization-code registry, canonical patterns, and exception process.

## Design principles

Use the following layers together instead of implementing every control independently in each resource module:

| Layer | Responsibility |
| --- | --- |
| Central naming module | Generate deterministic, enterprise-compliant names from approved tokens. |
| Resource wrapper | Validate Azure service-specific requirements, such as allowed characters and name length. |
| Landing-zone pattern or deployment root | Supply naming context, mandatory tags, and approved configurations. |
| Azure Policy | Audit or deny noncompliant resources and add or require tags where technically reliable. |

This approach keeps low-level wrappers reusable while allowing landing-zone patterns to enforce Advocate Health standards.

## 1. Naming

### 1.1 Add service-level name validation to each resource module

Every resource wrapper should validate the Azure requirements for its `name` input. Validation should cover, where applicable:

- Minimum and maximum length.
- Allowed characters and casing.
- Valid first and last characters.
- Reserved words or service-specific restrictions.
- Whether an empty or null name is allowed.

For example, the Private Endpoint wrapper can validate Azure's resource-name constraints:

```hcl
variable "name" {
  description = "Enterprise-generated name of the private endpoint."
  type        = string
  nullable    = false

  validation {
    condition = (
      length(var.name) >= 2 &&
      length(var.name) <= 64 &&
      can(regex(
        "^[A-Za-z0-9](?:[A-Za-z0-9._-]{0,62}[A-Za-z0-9_])?$",
        var.name
      ))
    )
    error_message = "Private endpoint name must be 2-64 characters, begin with an alphanumeric character, and end with an alphanumeric character or underscore."
  }
}
```

Service-level validation prevents invalid Azure requests, but it does not enforce the complete enterprise naming convention.

### 1.2 Create a central naming module

Create one centrally maintained naming module that implements the approved token registry and resource-specific naming patterns.

```text
modules/custom/naming/
├── main.tf
├── variables.tf
├── outputs.tf
└── test/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── versions.tf
```

The module should accept semantic inputs rather than a partially constructed name:

```hcl
module "private_endpoint_name" {
  source = "../../../modules/custom/naming"

  org_code       = var.org_code
  resource_type  = "pep"
  workload_code  = var.target_code
  region_code    = var.region_code
  cloud_env_code = var.cloud_env_code
  instance       = var.instance
}
```

For approved input values, it could return:

```text
ah-pep-kv-wus3-azp-01
```

The deployment root or landing-zone pattern passes the generated value to the resource wrapper:

```hcl
module "private_endpoint" {
  source = "../../../modules/avm/private-endpoint"

  name = module.private_endpoint_name.name
  # Additional resource configuration omitted.
}
```

The naming module should:

- Validate `org_code` against the approved organization registry.
- Validate resource, workload, purpose, region, and cloud-environment tokens against controlled catalogs.
- Format the instance as two digits by default.
- Apply the correct delimiter and casing rules.
- Apply approved constrained-resource patterns, such as storage account names without hyphens.
- Enforce Azure service length and character restrictions on the generated result.
- Support documented service exceptions, such as provider-defined Private DNS zone names.
- Return both the generated name and normalized tokens when useful for tests and reporting.
- Produce the same name for the same inputs.

Do not duplicate the complete token catalog or enterprise pattern in every AVM wrapper. Wrappers should accept the generated name and enforce only service-specific constraints.

### 1.3 Resolve naming-standard ambiguities before strict enforcement

The naming authority should resolve the following differences in the current draft before automated controls or Azure Policy deny noncompliant names:

- The resource-group pattern places `rg` near the beginning in one section and at the end in another.
- The management-group examples are inconsistent about including the `mg` token.
- The approved value and registry for `org_code` are still pending.

Record and test one canonical pattern for each resource type after these decisions are approved.

### Acceptance criteria

- Each resource module rejects names that violate the applicable Azure service constraints.
- Deployment roots generate names through the central naming module.
- Unit tests cover valid names, invalid tokens, length boundaries, constrained names, and service exceptions.
- Existing resources are not renamed automatically; legacy and approved exceptions follow the documented exception process.

## 2. Mandatory tags

Make the `tags` variable required in every module that creates a taggable Azure resource. Remove its default value and set `nullable = false` so callers must explicitly provide a tag map:

```hcl
variable "tags" {
  description = "Mandatory and additional tags applied to the resource."
  type        = map(string)
  nullable    = false

  validation {
    condition     = length(var.tags) > 0
    error_message = "At least one tag must be provided."
  }
}
```

Making `tags` required is a breaking change for existing callers. Update all deployment roots and tests as part of the same change.

### Mandatory and additional tags

- **Mandatory tags** are the enterprise-governed tags required on applicable resources, including `Organization`, `Application`, `CostCenter`, `Department`, `Environment`, `BusinessUnit`, `BusinessOwner`, `TechnicalOwner`, `SupportGroup`, `ServiceId`, `Criticality`, `DataClassification`, `Compliance`, `Lifecycle`, `ManagedBy`, and `Repository`. Include `BackupTier` where applicable.
- **Additional tags** are optional resource- or workload-specific metadata supplied by the caller. They must not replace protected mandatory values.

Build the mandatory tags in the landing-zone pattern or deployment root, merge them with optional additional tags, and pass the resulting map to the wrapper. Merge mandatory tags last so they take precedence:

```hcl
locals {
  mandatory_tags = {
    Organization       = var.org_code
    Application        = var.application
    CostCenter         = var.cost_center
    Department         = var.department
    Environment        = var.environment
    BusinessUnit       = var.business_unit
    BusinessOwner      = var.business_owner
    TechnicalOwner     = var.technical_owner
    SupportGroup       = var.support_group
    ServiceId          = var.service_id
    Criticality        = var.criticality
    DataClassification = var.data_classification
    Compliance         = var.compliance
    Lifecycle          = var.lifecycle
    ManagedBy          = "Terraform"
    Repository         = var.repository
  }

  effective_tags = merge(var.additional_tags, local.mandatory_tags)
}
```

Requiring the variable ensures that callers provide tags, but it does not prove that every mandatory key is present. Validate mandatory keys and controlled values in the landing-zone pattern, and use Azure Policy to audit or enforce tags on resources created outside Terraform. Do not place patient, employee, credential, secret, or other sensitive data in tags.

### Acceptance criteria

- Every taggable module defines `tags` as a required, non-null variable.
- Every taggable resource receives all applicable mandatory tags.
- Mandatory tag keys use the exact approved casing.
- Additional tags cannot override protected mandatory values.
- Controlled values are validated before planning.
- Azure Policy reports resources created manually or outside Terraform that are missing tags.

## 3. Approved SKUs

Only modules for resources with an SKU should expose SKU validation. Maintain approved SKU sets by resource type and environment rather than using one repository-wide list.

SKU controls should account for:

- Production versus non-production requirements.
- Availability-zone and regional support.
- Security and feature requirements.
- Cost-management limits.
- Disaster-recovery requirements.
- Provider or service deprecations.

Prefer Azure Policy for broad enforcement and module validation for early developer feedback.

### Acceptance criteria

- Invalid SKUs fail before deployment when they can be determined during planning.
- Azure Policy enforces approved SKUs for resources created outside Terraform.
- Exceptions are documented and time-bound.

## 4. Security and policy-compliant defaults

Modules should use secure defaults where doing so is safe, supported, and consistent with the enterprise policy baseline. Examples include:

- Disable public network access unless it is explicitly required and approved.
- Use Microsoft Entra authentication instead of Shared Key authentication where supported.
- Require the minimum approved TLS version.
- Prefer private endpoints for supported platform services.
- Disable insecure protocols and legacy authentication methods.
- Enable managed identities where supported.
- Expose resource locks and role assignments through standard AVM interfaces.
- Avoid broad default RBAC assignments.
- Mark sensitive variables as `sensitive = true` and avoid sensitive outputs.

Not every security decision belongs in a low-level wrapper. Use Azure Policy for tenant- or management-group-wide guardrails, and use pattern modules for controls that require multiple coordinated resources.

Any default that changes upstream AVM behavior must be documented because it creates an Advocate Health-specific contract and may be a breaking change for existing consumers.

### Acceptance criteria

- Defaults comply with the approved Azure Policy baseline.
- A consumer must make an explicit, documented choice to weaken a secure default.
- Security exceptions include an owner, reason, compensating control, and expiration or review date.
- Integration tests run in a subscription where the applicable enterprise policies are assigned.

## 5. Proposed implementation sequence

| Priority | Enhancement | Rationale |
| --- | --- | --- |
| 1 | Obtain approval for canonical naming patterns and the organization-code registry. | Strict enforcement requires an authoritative standard. |
| 2 | Add Azure service-level name validation to existing wrappers. | Provides immediate feedback without changing module architecture. |
| 3 | Implement and test the central naming module. | Establishes one source of truth for generated names. |
| 4 | Implement common mandatory tags in landing-zone patterns or deployment roots. | Establishes consistent governance metadata. |
| 5 | Add approved SKU registries. | Aligns deployments with architecture and cost controls. |
| 6 | Apply secure and policy-compliant defaults. | Reduces preventable security misconfiguration. |
| 7 | Roll out Azure Policy in audit mode, then enable deny or remediation selectively. | Covers resources deployed outside Terraform without disrupting adoption. |

## 6. Decisions required

The following decisions are needed before implementation is considered complete:

- Approve the organization code and registry owner.
- Resolve the Resource Group and Management Group pattern inconsistencies.
- Decide whether thin AVM wrappers remain generic or become governed Advocate Health wrappers.
- Select the owner and authoritative source for controlled token, SKU, and tag-value registries.
- Define the exception approval, expiration, and reporting process.
- Approve the policy-enforcement rollout from audit to deny or remediation.

## Expected outcome

After implementation, deployment roots will generate deterministic names and mandatory tags from controlled inputs. Resource wrappers will reject values that Azure cannot accept. Azure Policy will provide additional controls for resources deployed outside Terraform. This creates a clear separation between reusable resource implementation and enterprise governance while keeping both consistently enforced.

<!--
## Deferred topics for later discussion

### Approved locations

Define the approved Azure-location registry, region-code mappings, validation ownership, and Azure Policy enforcement before restricting module location inputs.

### Diagnostic settings

Establish a consistent diagnostics interface for resources that support Azure Monitor diagnostic settings.

The preferred ownership model is:

- Deployment roots provide central destination IDs, such as Log Analytics workspace, storage account, or Event Hub IDs.
- Resource wrappers expose the upstream AVM `diagnostic_settings` interface when available.
- Azure Policy deploys or audits diagnostics for resource types where centralized enforcement is more reliable.

Do not assume every resource exposes the same log categories. Prefer category groups such as `allLogs` and `audit` where supported, and document resource-specific exceptions.

Sensitive diagnostic destination IDs should be supplied by configuration; they should not be hardcoded in reusable modules.

#### Acceptance criteria

- Supported production resources send required logs and metrics to approved destinations.
- Diagnostic settings do not duplicate settings deployed by Azure Policy.
- Tests verify the configured destination and enabled category groups.
- Unsupported resource types and approved exceptions are documented.

Decision required: Determine whether diagnostics are primarily module-managed or policy-managed for each resource type.

### CI/CD and testing

Add the following controls to pull-request validation:

1. `terraform fmt -check`.
2. `terraform init -backend=false` and `terraform validate`.
3. Naming-module unit tests and resource-boundary tests.
4. Mandatory-tag tests.
5. Terraform linting and security scanning.
6. A reviewed Terraform plan for deployable roots when credentials and environment isolation allow it.
7. Integration deployment in a governed test subscription before production release.

Use immutable saved plans between approval and apply where practical. A protected apply must not recalculate different naming inputs or tags from those reviewed in the plan.

Deferred implementation items:

- Enable naming and tag checks in pull requests.
- Standardize diagnostic-setting inputs and destinations.
-->
