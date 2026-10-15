locals {
  module_version = "avm-key-vault-v1.0.0"
  tags = merge(var.tags, {
    module_version = local.module_version
  })
}

module "this" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.11.0"

  location                                = var.location
  name                                    = var.name
  resource_group_name                     = var.resource_group_name
  tenant_id                               = var.tenant_id
  contacts                                = var.contacts
  diagnostic_settings                     = var.diagnostic_settings
  enable_telemetry                        = var.enable_telemetry
  enabled_for_deployment                  = var.enabled_for_deployment
  enabled_for_disk_encryption             = var.enabled_for_disk_encryption
  enabled_for_template_deployment         = var.enabled_for_template_deployment
  keys                                    = var.keys
  legacy_access_policies                  = var.legacy_access_policies
  legacy_access_policies_enabled          = var.legacy_access_policies_enabled
  lock                                    = var.lock
  network_acls                            = var.network_acls
  private_endpoints                       = var.private_endpoints
  private_endpoints_manage_dns_zone_group = var.private_endpoints_manage_dns_zone_group
  public_network_access_enabled           = var.public_network_access_enabled
  purge_protection_enabled                = var.purge_protection_enabled
  role_assignments                        = var.role_assignments
  secrets                                 = var.secrets
  secrets_value                           = var.secrets_value
  secrets_value_wo                        = var.secrets_value_wo
  secrets_value_wo_version                = var.secrets_value_wo_version
  sku_name                                = var.sku_name
  soft_delete_retention_days              = var.soft_delete_retention_days
  tags                                    = local.tags
  wait_for_rbac_before_contact_operations = var.wait_for_rbac_before_contact_operations
  wait_for_rbac_before_key_operations     = var.wait_for_rbac_before_key_operations
  wait_for_rbac_before_secret_operations  = var.wait_for_rbac_before_secret_operations
}
