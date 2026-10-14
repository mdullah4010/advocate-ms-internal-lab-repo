# Azure Firewall

Terraform wrapper for the [Azure Firewall Azure Verified Module](https://registry.terraform.io/modules/Azure/avm-res-network-azurefirewall/azurerm/0.4.0), pinned to version `0.4.0`.

## Usage

```hcl
module "firewall" {
  source = "git::https://github.com/ah-enterprise-cloud-services/terraform-azure-modules.git//avm/firewall?ref=avm-firewall-v1.0.0"

  firewall_sku_name   = "AZFW_VNet"
  firewall_sku_tier   = "Standard"
  location            = "eastus2"
  name                = "afw-example-eastus2"
  resource_group_name = azurerm_resource_group.example.name
  firewall_ip_configuration = {
    ipconfig = {
      name                 = "ipconfig"
      subnet_id            = azurerm_subnet.azure_firewall.id
      public_ip_address_id = azurerm_public_ip.firewall.id
    }
  }
}
```

See [variables.tf](./variables.tf) for all supported inputs and defaults.

## Outputs

The module exports `resource`, `resource_id`, and `id`. See [outputs.tf](./outputs.tf) for definitions.

## Validation

Run the `Terraform Module Deployment Test` workflow with `module_name` set to `avm/firewall`. See the [module development guidelines](../../README.md#testing-and-validation).

## Changelog

Add future releases in descending version order and summarize module changes and enhancements.

### v1.0.0

- Initial release of the module wrapper.
- Added deployable sample test values for every module input.
- Added the module release tag version to deployed resource tags.