output "id" {
  description = "Management group resource ID."
  value       = azurerm_management_group.this.id
}

output "name" {
  description = "Management group ID."
  value       = azurerm_management_group.this.name
}
