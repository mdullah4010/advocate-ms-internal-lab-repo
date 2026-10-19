output "resource_group_id" {
  description = "Resource ID of the temporary test resource group."
  value       = azurerm_resource_group.this.id
}

output "name" {
  description = "Name of the resource created by the test root."
  value       = module.under_test.name
}

output "resource_id" {
  description = "Resource ID of the resource created by the test root."
  sensitive   = true
  value       = module.under_test.resource_id
}
