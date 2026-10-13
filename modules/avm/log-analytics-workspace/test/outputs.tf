output "resource_group_id" {
  description = "Resource ID of the temporary test resource group."
  value       = module.resource_group.id
}

output "resource_group_name" {
  description = "Name of the temporary test resource group."
  value       = module.resource_group.name
}

output "workspace_id" {
  description = "Resource ID of the test Log Analytics workspace."
  value       = module.log_analytics_workspace.resource_id
}

output "workspace_name" {
  description = "Name of the test Log Analytics workspace."
  value       = module.log_analytics_workspace.name
}
