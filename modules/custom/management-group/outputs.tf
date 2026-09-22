output "id" {
  description = "Management group resource ID."
  value       = azurerm_management_group.this.id
}

output "name" {
  description = "Management group ID."
  value       = azurerm_management_group.this.name
}

output "display_name" {
  description = "Management group display name."
  value       = azurerm_management_group.this.display_name
}

output "parent_management_group_id" {
  description = "Resource ID of the parent management group."
  value       = azurerm_management_group.this.parent_management_group_id
}

output "subscription_ids" {
  description = "Subscription IDs assigned to the management group."
  value       = azurerm_management_group.this.subscription_ids
}

output "tenant_scoped_id" {
  description = "Management group resource ID prefixed with the tenant ID."
  value       = azurerm_management_group.this.tenant_scoped_id
}
