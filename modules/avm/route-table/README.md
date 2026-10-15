# Azure Route Table

Terraform wrapper for the [Azure Route Table Azure Verified Module](https://registry.terraform.io/modules/Azure/avm-res-network-routetable/azurerm/0.5.0), pinned to version `0.5.0`.

## Usage

```hcl
module "route_table" {
  source = "git::https://github.com/ah-enterprise-cloud-services/terraform-azure-modules.git//avm/route-table?ref=avm-route-table-v1.0.0"

  location            = "eastus2"
  name                = "rt-example-eastus2"
  resource_group_name = azurerm_resource_group.example.name
  tags                = { environment = "example" }
}
```

See [variables.tf](./variables.tf) for all supported inputs and defaults.

## Outputs

The module exports `name`, `resource`, `resource_id`, and `routes`. See [outputs.tf](./outputs.tf) for definitions.

## Validation

Run the `Terraform Module Deployment Test` workflow with `module_name` set to `avm/route-table`. See the [module development guidelines](../../README.md#testing-and-validation).

## Changelog

Add future releases in descending version order and summarize module changes and enhancements.

### v1.0.0

- Initial release of the module wrapper.
- Added deployable sample test values for every module input.
- Added the module release tag version to deployed resource tags.