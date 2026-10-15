output "firewall_id" {
  description = "Resource ID of the test Azure Firewall."
  value       = module.firewall.resource_id
}

output "resource_group_id" {
  description = "Resource ID of the temporary test resource group."
  value       = module.resource_group.id
}

output "resource_group_name" {
  description = "Name of the temporary test resource group."
  value       = module.resource_group.name
}