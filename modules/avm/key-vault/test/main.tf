locals {
  suffix              = substr(sha256(var.test_run_id), 0, 12)
  key_vault_name      = "kv-${local.suffix}"
  resource_group_name = "rg-kv-module-test-${local.suffix}"
}

module "resource_group" {
  source = "../../resource-group"

  name     = coalesce(var.resource_group_name, local.resource_group_name)
  location = var.location
  tags     = var.tags
}

module "key_vault" {
  source = "./.."

  contacts                                = var.contacts
  diagnostic_settings                     = var.diagnostic_settings
  enable_telemetry                        = var.enable_telemetry
  enabled_for_deployment                  = var.enabled_for_deployment
  enabled_for_disk_encryption             = var.enabled_for_disk_encryption
  enabled_for_template_deployment         = var.enabled_for_template_deployment
  keys                                    = var.keys
  legacy_access_policies                  = var.legacy_access_policies
  legacy_access_policies_enabled          = var.legacy_access_policies_enabled
  location                                = var.location
  lock                                    = var.lock
  name                                    = coalesce(var.name, local.key_vault_name)
  network_acls                            = var.network_acls
  private_endpoints                       = var.private_endpoints
  private_endpoints_manage_dns_zone_group = var.private_endpoints_manage_dns_zone_group
  public_network_access_enabled           = var.public_network_access_enabled
  purge_protection_enabled                = var.purge_protection_enabled
  resource_group_name                     = module.resource_group.name
  role_assignments                        = var.role_assignments
  secrets                                 = var.secrets
  secrets_value                           = var.secrets_value
  secrets_value_wo                        = var.secrets_value_wo
  secrets_value_wo_version                = var.secrets_value_wo_version
  sku_name                                = var.sku_name
  soft_delete_retention_days              = var.soft_delete_retention_days
  tags                                    = var.tags
  tenant_id                               = coalesce(var.module_tenant_id, var.tenant_id)
  wait_for_rbac_before_contact_operations = var.wait_for_rbac_before_contact_operations
  wait_for_rbac_before_key_operations     = var.wait_for_rbac_before_key_operations
  wait_for_rbac_before_secret_operations  = var.wait_for_rbac_before_secret_operations
}
