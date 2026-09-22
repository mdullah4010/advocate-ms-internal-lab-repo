output "resource_group_id" {
  description = "Resource ID of the temporary test resource group."
  value       = module.resource_group.id
}

output "resource_group_name" {
  description = "Name of the temporary test resource group."
  value       = module.resource_group.name
}

output "virtual_network_id" {
  description = "Resource ID of the primary test virtual network."
  value       = module.virtual_network.id
}

output "virtual_network_name" {
  description = "Name of the primary test virtual network."
  value       = module.virtual_network.name
}

output "subnets" {
  description = "Information about subnets created in the primary test virtual network."
  value       = module.virtual_network.subnets
}

output "secondary_virtual_network_id" {
  description = "Resource ID of the secondary peered test virtual network."
  value       = module.secondary_virtual_network.id
}

output "secondary_virtual_network_name" {
  description = "Name of the secondary peered test virtual network."
  value       = module.secondary_virtual_network.name
}

output "secondary_subnets" {
  description = "Information about subnets created in the secondary test virtual network."
  value       = module.secondary_virtual_network.subnets
}

output "peerings" {
  description = "Information about the bidirectional virtual network peerings."
  value       = module.virtual_network.peerings
}
