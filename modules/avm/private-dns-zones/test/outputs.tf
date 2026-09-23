output "resource_group_id" {
  description = "Resource ID of the temporary test resource group."
  value       = module.resource_group.id
}

output "virtual_network_id" {
  description = "Resource ID of the test virtual network."
  value       = module.virtual_network.id
}

output "private_dns_zone_resource_ids" {
  description = "Map of private DNS zone keys to resource IDs created by the module."
  value       = module.private_dns_zones.private_dns_zone_resource_ids
}

output "private_link_private_dns_zones_map" {
  description = "Private DNS zone configuration returned by the module."
  value       = module.private_dns_zones.private_link_private_dns_zones_map
}

output "private_dns_zone_resource_group_id" {
  description = "Resource group ID returned by the private DNS zones module."
  value       = module.private_dns_zones.resource_group_resource_id
}