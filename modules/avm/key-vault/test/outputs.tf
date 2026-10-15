output "key_vault_id" {
  description = "Resource ID of the temporary test Key Vault."
  value       = module.key_vault.resource_id
}

output "key_vault_name" {
  description = "Name of the temporary test Key Vault."
  value       = module.key_vault.name
}

output "key_vault_uri" {
  description = "URI of the temporary test Key Vault."
  value       = module.key_vault.uri
}

output "resource_group_id" {
  description = "Resource ID of the temporary test resource group."
  value       = module.resource_group.id
}

output "resource_group_name" {
  description = "Name of the temporary test resource group."
  value       = module.resource_group.name
}
