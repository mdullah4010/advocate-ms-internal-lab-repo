## Module development guidelines

Module development progress is tracked in the [Advocate Health Azure Landing Zones Module Tracker](https://microsoft.sharepoint.com/:x:/t/CT-51961/cQp8MYlee3N2QJV7M3X95d7xEgUCe4KCc-YgizjCUC6mKREzQg). Update the tracker when module development starts, its status changes, or work is completed.

### Module selection

1. Check the official [Azure Verified Modules](https://azure.github.io/Azure-Verified-Modules/) catalog before developing or materially updating an Azure resource module.
2. Use an Azure Verified Module whenever one exists for the required Azure resource or deployment pattern. Do not recreate functionality already supported by the AVM unless a documented requirement cannot be met by it.
3. Confirm the latest available AVM release in the Terraform Registry when the wrapper is created or updated. Pin that exact version in the module block to keep deployments deterministic.
4. Review release notes, provider constraints, required inputs, outputs, and breaking changes before upgrading an AVM version.

### Directory structure

- Place wrappers backed by Azure Verified Modules under `modules/avm/<module-name>`.
- Place modules for Azure services without a suitable Azure Verified Module under `modules/custom/<module-name>`.
- Do not add new Azure resource modules directly under `modules`.
- Use lowercase, hyphen-separated directory names.

```text
modules/
├── avm/
│   └── <module-name>/
└── custom/
    └── <module-name>/
```

### Wrapper design

- Use the following standard structure for every module:

```text
<module-name>/
├── main.tf
├── variables.tf
├── outputs.tf
└── test/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── versions.tf
    └── test.auto.tfvars.example
```

- `main.tf` defines the upstream AVM call or custom Azure resources.
- `variables.tf` defines all required and optional module inputs.
- `outputs.tf` exposes relevant resource identifiers and properties.
- `test/` contains an independently deployable Terraform root used by the module test workflow.
- Expose all required and optional inputs supported by the upstream AVM so consumers can configure the complete module capability while deployment requirements are still being defined. Preserve the upstream input types, defaults, validation behavior, and descriptions wherever possible.
- Declare clear variable descriptions, types, defaults, and validation rules.
- Pin module versions explicitly and use provider constraints compatible with the selected AVM version.
- Document the upstream AVM source and pinned version in this catalog whenever an AVM wrapper is added or upgraded.

### Testing and validation

- Develop module changes in a feature branch and merge them into `main` only after development, review, and local validation are complete.
- The module deployment workflow currently runs only from `main`. Deployment testing with the workflow is therefore available only after the feature branch has been merged.
- Add deployable test code under `modules/<category>/<module-name>/test`.
- Test roots used by the central workflow must accept `tenant_id`, `subscription_id`, `location`, and `test_run_id` variables and declare an AzureRM backend.
- Derive temporary resource names from `test_run_id` to prevent collisions between workflow runs.
- Run the central module workflow with the category-qualified path, such as `avm/virtual-network` or `custom/<module-name>`.
- Run `terraform fmt`, `terraform init`, `terraform validate`, and review a Terraform plan before merging.
