locals {
  resource_group_name = "rg-law-module-test-${var.test_run_id}"
  workspace_name      = "law${substr(replace(var.test_run_id, "-", ""), 0, 55)}x"
}

module "resource_group" {
  source = "../../resource-group"

  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

module "log_analytics_workspace" {
  source = "./.."

  name                = local.workspace_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tags                = var.tags
}
