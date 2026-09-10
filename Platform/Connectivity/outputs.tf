output "resource_group_id" {
  description = "Resource ID of the hub connectivity resource group."
  value       = module.connectivity_resource_group.id
}

output "resource_group_name" {
  description = "Name of the hub connectivity resource group."
  value       = module.connectivity_resource_group.name
}

output "hub_virtual_network_id" {
  description = "Resource ID of the hub virtual network."
  value       = module.hub_virtual_network.id
}

output "hub_virtual_network_name" {
  description = "Name of the hub virtual network."
  value       = module.hub_virtual_network.name
}

output "subnet_ids" {
  description = "Hub subnet resource IDs keyed by subnet name."
  value       = { for name, subnet in module.hub_subnet : name => subnet.id }
}
