# Azure Virtual Network

Terraform wrapper for the [Azure Virtual Network Azure Verified Module](https://registry.terraform.io/modules/Azure/avm-res-network-virtualnetwork/azurerm/0.22.2), pinned to version `0.22.2`.

## Usage

```hcl
module "virtual_network" {
  source = "git::https://github.com/ah-enterprise-cloud-services/terraform-azure-modules.git//avm/virtual-network?ref=avm-virtual-network-v1.0.0"

  address_space = ["10.0.0.0/16"]
  location      = "eastus2"
  name          = "vnet-example-eastus2"
  parent_id     = azurerm_resource_group.example.id
  tags          = { environment = "example" }
}
```

See [variables.tf](./variables.tf) for all supported inputs and defaults.

## Outputs

The module exports `address_spaces`, `id`, `name`, `peerings`, `resource`, `resource_id`, and `subnets`. See [outputs.tf](./outputs.tf) for definitions.

## Validation

Run the `Terraform Module Deployment Test` workflow with `module_name` set to `avm/virtual-network`. See the [module development guidelines](../../README.md#testing-and-validation).

## Changelog

Add future releases in descending version order and summarize module changes and enhancements.

### v1.0.0

- Initial release of the module wrapper.
- Added deployable sample test values for every module input.
- Added the module release tag version to deployed resource tags.