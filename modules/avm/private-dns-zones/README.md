# Azure Private DNS Zone

Terraform wrapper for the [Azure Private DNS Zone Azure Verified Module](https://registry.terraform.io/modules/Azure/avm-res-network-privatednszone/azurerm/0.5.0), pinned to version `0.5.0`.

## Usage

```hcl
module "private_dns_zone" {
  source = "git::https://github.com/ah-enterprise-cloud-services/terraform-azure-modules.git//avm/private-dns-zones?ref=avm-private-dns-zones-v1.0.0"

  domain_name = "privatelink.blob.core.windows.net"
  parent_id   = azurerm_resource_group.example.id
  tags        = { environment = "example" }
}
```

See [variables.tf](./variables.tf) for all supported records, virtual network links, inputs, and defaults.

## Outputs

The module exports the zone `name`, `resource`, `resource_id`, record outputs, and virtual network link outputs. See [outputs.tf](./outputs.tf) for definitions.

## Validation

Run the `Terraform Module Deployment Test` workflow with `module_name` set to `avm/private-dns-zones`. See the [module development guidelines](../../README.md#testing-and-validation).

## Changelog

Add future releases in descending version order and summarize module changes and enhancements.

### v1.0.0

- Initial release of the module wrapper.
- Added deployable sample test values for every module input.
- Added the module release tag version to deployed resource tags.