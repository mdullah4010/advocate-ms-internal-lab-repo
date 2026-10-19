output "name" {
  description = "The name of the App Service Plan."
  value       = module.this.name
}

output "resource_id" {
  description = "The resource ID of the App Service Plan."
  value       = module.this.resource_id
}
