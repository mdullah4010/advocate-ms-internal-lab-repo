# Azure Private Endpoint

Terraform wrapper for the [Azure Private Endpoint Azure Verified Module](https://registry.terraform.io/modules/Azure/avm-res-network-privateendpoint/azurerm/0.2.0), pinned to version `0.2.0`.

## Usage

```hcl
module "private_endpoint" {
  source = "git::https://github.com/ah-enterprise-cloud-services/terraform-azure-modules.git//avm/private-endpoint?ref=avm-private-endpoint-v1.0.0"

  location                       = "eastus2"
  name                           = "pep-example-eastus2"
  network_interface_name         = "nic-pep-example-eastus2"
  private_connection_resource_id = azurerm_storage_account.example.id
  resource_group_name            = azurerm_resource_group.example.name
  subnet_resource_id             = azurerm_subnet.private_endpoints.id
  subresource_names              = ["blob"]
}
```

See [variables.tf](./variables.tf) for all supported inputs and defaults.

## Outputs

The module exports `id`, `name`, `resource`, and `resource_id`. See [outputs.tf](./outputs.tf) for definitions.

## Validation

Run the `Terraform Module Deployment Test` workflow with `module_name` set to `avm/private-endpoint`. See the [module development guidelines](../../README.md#testing-and-validation).

## Changelog

Add future releases in descending version order and summarize module changes and enhancements.

### v1.0.0

- Initial release of the module wrapper.
- Added deployable sample test values for every module input.
- Added the module release tag version to deployed resource tags.