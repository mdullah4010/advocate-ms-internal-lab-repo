locals {
  suffix              = substr(sha256(var.test_run_id), 0, 12)
  key_vault_name      = "kv-${local.suffix}"
  resource_group_name = "rg-kv-module-test-${local.suffix}"
}

module "resource_group" {
  source = "../../resource-group"

  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

module "key_vault" {
  source = "./.."

  name                = local.key_vault_name
  location            = module.resource_group.location
  resource_group_name = module.resource_group.name
  tenant_id           = var.tenant_id
  tags                = var.tags
}
