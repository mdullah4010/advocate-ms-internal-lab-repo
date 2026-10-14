# Azure DNS Private Resolver

Terraform wrapper for the [Azure DNS Private Resolver Azure Verified Module](https://registry.terraform.io/modules/Azure/avm-res-network-dnsresolver/azurerm/0.8.0), pinned to version `0.8.0`.

## Usage

```hcl
module "private_dns_resolver" {
  source = "git::https://github.com/ah-enterprise-cloud-services/terraform-azure-modules.git//avm/private-dns-resolver?ref=avm-private-dns-resolver-v1.0.0"

  location                    = "eastus2"
  name                        = "dnspr-example-eastus2"
  resource_group_name         = azurerm_resource_group.example.name
  virtual_network_resource_id = azurerm_virtual_network.example.id
}
```

See [variables.tf](./variables.tf) for all supported inputs and defaults.

## Outputs

The module exports `forwarding_rulesets`, `inbound_endpoint_ips`, `inbound_endpoints`, `name`, `outbound_endpoints`, `resource`, and `resource_id`. See [outputs.tf](./outputs.tf) for definitions.

## Validation

Run the `Terraform Module Deployment Test` workflow with `module_name` set to `avm/private-dns-resolver`. See the [module development guidelines](../../README.md#testing-and-validation).

## Changelog

Add future releases in descending version order and summarize module changes and enhancements.

### v1.0.0

- Initial release of the module wrapper.
- Added deployable sample test values for every module input.
- Added the module release tag version to deployed resource tags.