output "resource_group_id" {
  description = "Resource ID of the temporary test resource group."
  value       = module.resource_group.id
}

output "resource_group_name" {
  description = "Name of the temporary test resource group."
  value       = module.resource_group.name
}

output "virtual_network_id" {
  description = "Resource ID of the test virtual network."
  value       = module.virtual_network.id
}

output "subnet_id" {
  description = "Resource ID of the subnet associated with the route table."
  value       = module.virtual_network.subnets["route_table"].resource_id
}

output "route_table_id" {
  description = "Resource ID of the test route table."
  value       = module.route_table.resource_id
}

output "route_table_name" {
  description = "Name of the test route table."
  value       = module.route_table.name
}

output "routes" {
  description = "Routes created on the test route table."
  value       = module.route_table.routes
}