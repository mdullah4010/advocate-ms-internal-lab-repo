locals {
  resource_group_name = "rg-law-module-test-${var.test_run_id}"
  workspace_name      = "law${substr(replace(var.test_run_id, "-", ""), 0, 55)}x"
}

module "resource_group" {
  source = "../../resource-group"

  name     = coalesce(var.resource_group_name, local.resource_group_name)
  location = var.location
  tags     = var.tags
}

module "log_analytics_workspace" {
  source = "./.."

  customer_managed_key                                       = var.customer_managed_key
  diagnostic_settings                                        = var.diagnostic_settings
  enable_telemetry                                           = var.enable_telemetry
  location                                                   = var.location
  lock                                                       = var.lock
  log_analytics_workspace_allow_resource_only_permissions    = var.log_analytics_workspace_allow_resource_only_permissions
  log_analytics_workspace_cmk_for_query_forced               = var.log_analytics_workspace_cmk_for_query_forced
  log_analytics_workspace_daily_quota_gb                     = var.log_analytics_workspace_daily_quota_gb
  log_analytics_workspace_data_exports                       = var.log_analytics_workspace_data_exports
  log_analytics_workspace_dedicated_cluster_resource_id      = var.log_analytics_workspace_dedicated_cluster_resource_id
  log_analytics_workspace_identity                           = var.log_analytics_workspace_identity
  log_analytics_workspace_internet_ingestion_enabled         = var.log_analytics_workspace_internet_ingestion_enabled
  log_analytics_workspace_internet_query_enabled             = var.log_analytics_workspace_internet_query_enabled
  log_analytics_workspace_linked_storage_accounts            = var.log_analytics_workspace_linked_storage_accounts
  log_analytics_workspace_local_authentication_enabled       = var.log_analytics_workspace_local_authentication_enabled
  log_analytics_workspace_reservation_capacity_in_gb_per_day = var.log_analytics_workspace_reservation_capacity_in_gb_per_day
  log_analytics_workspace_retention_in_days                  = var.log_analytics_workspace_retention_in_days
  log_analytics_workspace_sku                                = var.log_analytics_workspace_sku
  log_analytics_workspace_tables                             = var.log_analytics_workspace_tables
  log_analytics_workspace_tables_update                      = var.log_analytics_workspace_tables_update
  log_analytics_workspace_timeouts                           = var.log_analytics_workspace_timeouts
  monitor_private_link_scope                                 = var.monitor_private_link_scope
  monitor_private_link_scoped_resource                       = var.monitor_private_link_scoped_resource
  monitor_private_link_scoped_service_name                   = var.monitor_private_link_scoped_service_name
  name                                                       = coalesce(var.name, local.workspace_name)
  network_security_perimeter_association                     = var.network_security_perimeter_association
  private_endpoint_extensions                                = var.private_endpoint_extensions
  private_endpoints                                          = var.private_endpoints
  resource_group_name                                        = module.resource_group.name
  role_assignments                                           = var.role_assignments
  tags                                                       = var.tags
}
