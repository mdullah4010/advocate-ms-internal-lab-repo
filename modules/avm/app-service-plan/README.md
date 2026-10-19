# App Service Plan

Terraform wrapper for the [Azure App Service Plan Azure Verified Module](https://registry.terraform.io/modules/Azure/avm-res-web-serverfarm/azurerm/2.0.8). The upstream module is pinned to version `2.0.8`.

## Usage

```hcl
module "app_service_plan" {
  source = "git::https://github.com/ah-enterprise-cloud-services/terraform-azure-modules.git//avm/app-service-plan?ref=avm-app-service-plan-v1.0.0"

  location  = azurerm_resource_group.example.location
  name      = "asp-example"
  os_type   = "Linux"
  parent_id = azurerm_resource_group.example.id
  sku_name  = "P1v2"

  tags = {
    environment = "example"
  }
}
```

See [variables.tf](./variables.tf) for all supported inputs and their defaults.

## Outputs

- `name` - App Service Plan name.
- `resource_id` - App Service Plan resource ID.

See [outputs.tf](./outputs.tf) for output definitions.

## Validation

Run the repository's `Terraform Module Deployment Test` workflow with `module_name` set to `avm/app-service-plan`. See the [module development guidelines](../../README.md#testing-and-validation) for the complete validation process.

## Changelog

Add future releases in descending version order and summarize module changes and enhancements.

### v1.0.0

- Initial release of the module wrapper.
- Added deployable sample test values for the test deployment inputs.
