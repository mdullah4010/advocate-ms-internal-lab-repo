# Azure Resource Group

Terraform wrapper for the [Azure Resource Group Azure Verified Module](https://registry.terraform.io/modules/Azure/avm-res-resources-resourcegroup/azurerm/0.4.0), pinned to version `0.4.0`.

## Usage

```hcl
module "resource_group" {
  source = "git::https://github.com/ah-enterprise-cloud-services/terraform-azure-modules.git//avm/resource-group?ref=avm-resource-group-v1.0.0"

  location = "eastus2"
  name     = "rg-example-eastus2"
  tags     = { environment = "example" }
}
```

See [variables.tf](./variables.tf) for all supported inputs and defaults.

## Outputs

The module exports `id`, `name`, `location`, `resource`, and `resource_id`. See [outputs.tf](./outputs.tf) for definitions.

## Validation

Run the `Terraform Module Deployment Test` workflow with `module_name` set to `avm/resource-group`. See the [module development guidelines](../../README.md#testing-and-validation).

## Changelog

Add future releases in descending version order and summarize module changes and enhancements.

### v1.0.0

- Initial release of the module wrapper.
- Added deployable sample test values for every module input.
- Added the module release tag version to deployed resource tags.