output "private_dns_zone_resource_ids" {
    description = "Map private DNS zone keys to their resource IDs."
    value       = module.this.private_dns_zone_resource_ids
}

output "private_link_private_dns_zones_map" {
    description = "Map of private link private DNS zones."
    value       = module.this.private_link_private_dns_zones_map
}

output "resource_group_resource_id" {
    description = "Resource ID of the resource group."
    value       = module.this.resource_group_resource_id
}