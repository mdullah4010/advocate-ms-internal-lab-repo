output "a_records" {
  description = "A records created in the test private DNS zone."
  value       = module.private_dns_zone.a_record_outputs
}

output "private_dns_zone_id" {
  description = "Resource ID of the test private DNS zone."
  value       = module.private_dns_zone.resource_id
}

output "private_dns_zone_name" {
  description = "Name of the test private DNS zone."
  value       = module.private_dns_zone.name
}

output "resource_group_id" {
  description = "Resource ID of the temporary test resource group."
  value       = module.resource_group.id
}

output "virtual_network_id" {
  description = "Resource ID of the test virtual network."
  value       = module.virtual_network.id
}

output "virtual_network_links" {
  description = "Virtual network links created for the test private DNS zone."
  value       = module.private_dns_zone.virtual_network_links_outputs
}