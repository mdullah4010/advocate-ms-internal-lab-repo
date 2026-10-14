# Azure Bastion

Terraform wrapper for the [Azure Bastion Host Azure Verified Module](https://registry.terraform.io/modules/Azure/avm-res-network-bastionhost/azurerm/0.9.0). The upstream module is pinned to version `0.9.0`.

## Usage

```hcl
module "bastion" {
  source = "git::https://github.com/ah-enterprise-cloud-services/terraform-azure-modules.git//avm/bastion?ref=avm-bastion-v1.0.0"

  location  = "eastus2"
  name      = "bas-example-eastus2"
  parent_id = azurerm_resource_group.example.id

  ip_configuration = {
    name      = "bastion-ip-configuration"
    subnet_id = azurerm_subnet.azure_bastion.id
  }

  tags = {
    environment = "example"
  }
}
```

See [variables.tf](./variables.tf) for all supported inputs and their defaults.

## Outputs

- `dns_name` - Bastion DNS name.
- `name` - Bastion resource name.
- `resource` - Bastion resource object.
- `resource_id` - Bastion resource ID.

See [outputs.tf](./outputs.tf) for output definitions.

## Validation

Run the repository's `Terraform Module Deployment Test` workflow with `module_name` set to `avm/bastion`. See the [module development guidelines](../../README.md#testing-and-validation) for the complete validation process.

## Changelog

Add future releases in descending version order and summarize module changes and enhancements.

### v1.0.0

- Initial release of the module wrapper.
- Added deployable sample test values for every module input.
- Added the module release tag version to deployed resource tags.