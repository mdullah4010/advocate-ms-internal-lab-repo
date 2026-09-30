locals {
  policy_name         = "afwp-${var.test_run_id}"
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

  location            = module.resource_group.location
  name                = local.policy_name
  resource_group_name = module.resource_group.name
  firewall_policy_sku = "Standard"
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
  tags = var.tags
}