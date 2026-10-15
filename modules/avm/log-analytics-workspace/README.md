# Log Analytics Workspace

Terraform wrapper for the [Log Analytics Workspace Azure Verified Module](https://registry.terraform.io/modules/Azure/avm-res-operationalinsights-workspace/azurerm/0.5.1), pinned to version `0.5.1`.

## Usage

```hcl
module "log_analytics_workspace" {
  source = "git::https://github.com/ah-enterprise-cloud-services/terraform-azure-modules.git//avm/log-analytics-workspace?ref=avm-log-analytics-workspace-v1.0.0"

  location            = "eastus2"
  name                = "log-example-eastus2"
  resource_group_name = azurerm_resource_group.example.name
  tags                = { environment = "example" }
}
```

See [variables.tf](./variables.tf) for all supported inputs and defaults.

## Outputs

The module exports `resource`, `resource_id`, `name`, `location`, and `private_endpoints`. See [outputs.tf](./outputs.tf) for definitions.

## Validation

Run the `Terraform Module Deployment Test` workflow with `module_name` set to `avm/log-analytics-workspace`. See the [module development guidelines](../../README.md#testing-and-validation).

## Changelog

Add future releases in descending version order and summarize module changes and enhancements.

### v1.0.0

- Initial release of the module wrapper.
- Added deployable sample test values for every module input.
- Added the module release tag version to deployed resource tags.