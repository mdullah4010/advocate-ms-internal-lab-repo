resource "azurerm_subnet" "this" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  virtual_network_name              = var.virtual_network_name
  address_prefixes                  = var.address_prefixes
  private_endpoint_network_policies = var.private_endpoint_network_policies_enabled ? "Enabled" : "Disabled"
}
