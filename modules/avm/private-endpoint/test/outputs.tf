output "resource_group_id" {
  description = "Resource ID of the test resource group."
  value       = module.resource_group.id
}

output "virtual_network_id" {
  description = "Resource ID of the test virtual network."
  value       = module.virtual_network.id
}

output "storage_account_id" {
  description = "Resource ID of the Private Link target storage account."
  value       = azurerm_storage_account.test.id
}

output "private_dns_zone_id" {
  description = "Resource ID of the private DNS zone associated with the private endpoint."
  value       = azurerm_private_dns_zone.blob.id
}

output "private_dns_zone_virtual_network_link_id" {
  description = "Resource ID of the test private DNS zone virtual network link."
  value       = azurerm_private_dns_zone_virtual_network_link.blob.id
}

output "private_endpoint_id" {
  description = "Resource ID of the private endpoint."
  value       = module.private_endpoint.id
}

output "private_endpoint_name" {
  description = "Name of the private endpoint."
  value       = module.private_endpoint.name
}
