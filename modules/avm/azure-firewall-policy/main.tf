module "this" {
  source  = "Azure/avm-res-network-firewallpolicy/azurerm"
  version = "0.3.4"

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
  location                                          = var.location
  lock                                              = var.lock
  name                                              = var.name
  resource_group_name                               = var.resource_group_name
  role_assignments                                  = var.role_assignments
  tags                                              = var.tags
}

module "rule_collection_group" {
  source   = "Azure/avm-res-network-firewallpolicy/azurerm//modules/rule_collection_groups"
  version  = "0.3.4"
  for_each = var.rule_collection_groups

  firewall_policy_rule_collection_group_firewall_policy_id          = module.this.resource_id
  firewall_policy_rule_collection_group_name                        = each.value.name
  firewall_policy_rule_collection_group_priority                    = each.value.priority
  firewall_policy_rule_collection_group_application_rule_collection = each.value.application_rule_collection
  firewall_policy_rule_collection_group_nat_rule_collection         = each.value.nat_rule_collection
  firewall_policy_rule_collection_group_network_rule_collection     = each.value.network_rule_collection
  firewall_policy_rule_collection_group_timeouts                    = each.value.timeouts
}