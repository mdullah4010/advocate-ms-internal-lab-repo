locals {
  resource_group_name = "rg-eh-test-${substr(replace(var.test_run_id, "-", ""), 0, 50)}"
  namespace_name      = "ehns${substr(lower(replace(var.test_run_id, "-", "")), 0, 44)}x"
}

module "resource_group" {
  source = "../../resource-group"

  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

module "event_hub" {
  source = "./.."

  name                          = local.namespace_name
  location                      = module.resource_group.location
  resource_group_name           = module.resource_group.name
  sku                           = "Basic"
  public_network_access_enabled = true
  tags                          = var.tags

  event_hubs = {
    test = {
      namespace_name      = local.namespace_name
      resource_group_name = module.resource_group.name
      partition_count     = 1
      message_retention   = 1
    }
  }
}
