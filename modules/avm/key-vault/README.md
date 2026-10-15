# Azure Key Vault

Terraform wrapper for the [Azure Key Vault Azure Verified Module](https://registry.terraform.io/modules/Azure/avm-res-keyvault-vault/azurerm/0.11.0), pinned to version `0.11.0`.

## Usage

```hcl
module "key_vault" {
  source = "git::https://github.com/ah-enterprise-cloud-services/terraform-azure-modules.git//avm/key-vault?ref=avm-key-vault-v1.0.0"

  location            = "eastus2"
  name                = "kv-example-eastus2"
  resource_group_name = azurerm_resource_group.example.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = { environment = "example" }
}
```

See [variables.tf](./variables.tf) for all supported inputs and defaults. Secret values are sensitive and must not be committed to source control.

## Outputs

The module exports `id`, `resource_id`, `name`, `uri`, `private_endpoints`, `keys`, `keys_resource_ids`, `secrets`, and `secrets_resource_ids`. See [outputs.tf](./outputs.tf) for definitions.

## Validation

Run the `Terraform Module Deployment Test` workflow with `module_name` set to `avm/key-vault`. See the [module development guidelines](../../README.md#testing-and-validation).

## Changelog

Add future releases in descending version order and summarize module changes and enhancements.

### v1.0.0

- Initial release of the module wrapper.
- Added deployable sample test values for every module input.
- Added the module release tag version to deployed resource tags.