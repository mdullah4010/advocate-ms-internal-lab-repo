module "this" {
  source  = "Azure/avm-res-network-privateendpoint/azurerm"
  version = "0.2.0"

  location                       = var.location
  name                           = var.name
  network_interface_name         = var.network_interface_name
  private_connection_resource_id = var.private_connection_resource_id
  resource_group_name            = var.resource_group_name
  subnet_resource_id             = var.subnet_resource_id

  application_security_group_association_ids = var.application_security_group_association_ids
  enable_telemetry                           = var.enable_telemetry
  ip_configurations                          = var.ip_configurations
  lock                                       = var.lock
  private_dns_zone_group_name                = var.private_dns_zone_group_name
  private_dns_zone_resource_ids              = var.private_dns_zone_resource_ids
  private_service_connection_name            = var.private_service_connection_name
  role_assignments                           = var.role_assignments
  subresource_names                          = var.subresource_names
  tags                                       = var.tags
}
