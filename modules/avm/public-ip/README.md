# Azure Public IP Address

Terraform wrapper for the [Azure Public IP Address Azure Verified Module](https://registry.terraform.io/modules/Azure/avm-res-network-publicipaddress/azurerm/0.2.1), pinned to version `0.2.1`.

## Usage

```hcl
module "public_ip" {
  source = "git::https://github.com/ah-enterprise-cloud-services/terraform-azure-modules.git//avm/public-ip?ref=avm-public-ip-v1.0.0"

  location            = "eastus2"
  name                = "pip-example-eastus2"
  resource_group_name = azurerm_resource_group.example.name
  tags                = { environment = "example" }
}
```

See [variables.tf](./variables.tf) for all supported inputs and defaults.

## Outputs

The module exports `public_ip_id`, `name`, `public_ip_address`, and `resource_id`. See [outputs.tf](./outputs.tf) for definitions.

## Validation

Run the `Terraform Module Deployment Test` workflow with `module_name` set to `avm/public-ip`. See the [module development guidelines](../../README.md#testing-and-validation).

## Changelog

Add future releases in descending version order and summarize module changes and enhancements.

### v1.0.0

- Initial release of the module wrapper.
- Added deployable sample test values for every module input.
- Added the module release tag version to deployed resource tags.