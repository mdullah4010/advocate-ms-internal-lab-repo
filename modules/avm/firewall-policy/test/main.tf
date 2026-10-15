locals {
  resource_group_name = "rg-afwp-test-${var.test_run_id}"
}

module "resource_group" {
  source = "../../resource-group"

  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}

module "firewall_policy" {
  source = "./.."

  location                                          = var.location
  name                                              = var.name
  resource_group_name                               = coalesce(var.resource_group_name, module.resource_group.name)
  diagnostic_settings                               = var.diagnostic_settings
  enable_telemetry                                  = var.enable_telemetry
  firewall_policy_auto_learn_private_ranges_enabled = var.firewall_policy_auto_learn_private_ranges_enabled
  firewall_policy_base_policy_id                    = var.firewall_policy_base_policy_id
  firewall_policy_dns                               = var.firewall_policy_dns
  firewall_policy_explicit_proxy                    = var.firewall_policy_explicit_proxy
  firewall_policy_identity                          = var.firewall_policy_identity
  firewall_policy_insights                          = var.firewall_policy_insights
  firewall_policy_intrusion_detection               = var.firewall_policy_intrusion_detection
  firewall_policy_private_ip_ranges                 = var.firewall_policy_private_ip_ranges
  firewall_policy_sku                               = var.firewall_policy_sku
  firewall_policy_sql_redirect_allowed              = var.firewall_policy_sql_redirect_allowed
  firewall_policy_threat_intelligence_allowlist     = var.firewall_policy_threat_intelligence_allowlist
  firewall_policy_threat_intelligence_mode          = var.firewall_policy_threat_intelligence_mode
  firewall_policy_timeouts                          = var.firewall_policy_timeouts
  firewall_policy_tls_certificate                   = var.firewall_policy_tls_certificate
  lock                                              = var.lock
  role_assignments                                  = var.role_assignments
  rule_collection_groups                            = var.rule_collection_groups
  tags                                              = var.tags
}