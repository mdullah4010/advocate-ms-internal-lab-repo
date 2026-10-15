location            = "westus3"
name                = "afwp-module-test"
resource_group_name = null

diagnostic_settings                               = {}
enable_telemetry                                  = false
firewall_policy_auto_learn_private_ranges_enabled = null
firewall_policy_base_policy_id                    = null
firewall_policy_dns = {
  proxy_enabled = false
  servers       = []
}
firewall_policy_explicit_proxy                = null
firewall_policy_identity                      = null
firewall_policy_insights                      = null
firewall_policy_intrusion_detection           = null
firewall_policy_private_ip_ranges             = ["IANAPrivateRanges"]
firewall_policy_sku                           = "Standard"
firewall_policy_sql_redirect_allowed          = false
firewall_policy_threat_intelligence_allowlist = null
firewall_policy_threat_intelligence_mode      = "Alert"
firewall_policy_timeouts                      = null
firewall_policy_tls_certificate               = null
lock                                          = null
role_assignments                              = {}

rule_collection_groups = {
  baseline = {
    name     = "BaselineRuleCollectionGroup"
    priority = 400
    network_rule_collection = [{
      action   = "Allow"
      name     = "AllowInternalHttps"
      priority = 100
      rule = [{
        name                  = "AllowInternalHttps"
        source_addresses      = ["10.0.0.0/24"]
        destination_addresses = ["10.1.0.0/24"]
        destination_ports     = ["443"]
        protocols             = ["TCP"]
      }]
    }]
  }
}

tags = {
  environment = "test"
  managedBy   = "terraform"
  purpose     = "azure-firewall-policy-module-test"
}