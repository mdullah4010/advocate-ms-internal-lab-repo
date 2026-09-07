output "id" {
  description = "Resource ID of the subnet."
  value       = azurerm_subnet.this.id
}

output "name" {
  description = "Name of the subnet."
  value       = azurerm_subnet.this.name
}
