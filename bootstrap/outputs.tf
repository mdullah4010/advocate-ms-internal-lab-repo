output "resource_group_name" {
  description = "Name of the deployed bootstrap resource group."
  value       = azurerm_resource_group.bootstrap.name
}

output "resource_group_location" {
  description = "Location of the deployed bootstrap resource group."
  value       = azurerm_resource_group.bootstrap.location
}
