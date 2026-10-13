output "id" {
  description = "Resource ID of the Azure Key Vault."
  value       = module.this.resource_id
}

output "resource_id" {
  description = "Resource ID of the Azure Key Vault."
  value       = module.this.resource_id
}

output "name" {
  description = "Name of the Azure Key Vault."
  value       = module.this.name
}

output "uri" {
  description = "URI of the Azure Key Vault for key and secret operations."
  value       = module.this.uri
}

output "private_endpoints" {
  description = "Private endpoints created for the Azure Key Vault."
  value       = module.this.private_endpoints
}

output "keys" {
  description = "Keys created in the Azure Key Vault."
  value       = module.this.keys
}

output "keys_resource_ids" {
  description = "Resource identifiers for keys created in the Azure Key Vault."
  value       = module.this.keys_resource_ids
}

output "secrets" {
  description = "Metadata for secrets created in the Azure Key Vault."
  value       = module.this.secrets
}

output "secrets_resource_ids" {
  description = "Resource identifiers for secrets created in the Azure Key Vault."
  value       = module.this.secrets_resource_ids
}
