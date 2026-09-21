data "azurerm_client_config" "current" {}

module "this" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.22.2"

  name          = var.name
  location      = var.location
  parent_id     = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"
  address_space = var.address_space
  dns_servers = length(var.dns_servers) > 0 ? {
    dns_servers = var.dns_servers
  } : null
  tags = var.tags
}
