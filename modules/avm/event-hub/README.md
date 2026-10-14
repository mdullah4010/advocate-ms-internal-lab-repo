# Event Hubs Namespace

Terraform wrapper for the [Event Hubs Namespace Azure Verified Module](https://registry.terraform.io/modules/Azure/avm-res-eventhub-namespace/azurerm/0.1.1), pinned to version `0.1.1`.

## Usage

```hcl
module "event_hub" {
  source = "git::https://github.com/ah-enterprise-cloud-services/terraform-azure-modules.git//avm/event-hub?ref=avm-event-hub-v1.0.0"

  location            = "eastus2"
  name                = "evhns-example-eastus2"
  resource_group_name = azurerm_resource_group.example.name
  tags                = { environment = "example" }
}
```

See [variables.tf](./variables.tf) for all supported inputs and defaults.

## Outputs

The module exports `resource`, `resource_id`, `event_hubs`, `private_endpoints`, `name`, and `location`. See [outputs.tf](./outputs.tf) for definitions.

## Validation

Run the `Terraform Module Deployment Test` workflow with `module_name` set to `avm/event-hub`. See the [module development guidelines](../../README.md#testing-and-validation).

## Changelog

Add future releases in descending version order and summarize module changes and enhancements.

### v1.0.0

- Initial release of the module wrapper.
- Added deployable sample test values for every module input.
- Added the module release tag version to deployed resource tags.