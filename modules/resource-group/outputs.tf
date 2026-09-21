output "id" {
  description = "Resource ID of the resource group."
  value       = module.this.resource_id
}

output "name" {
  description = "Name of the resource group."
  value       = module.this.name
}

output "location" {
  description = "Azure region of the resource group."
  value       = module.this.location
}
