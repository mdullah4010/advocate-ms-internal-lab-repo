output "resource" {
  description = "Full Log Analytics workspace resource output."
  sensitive   = true
  value       = module.this.resource
}

output "resource_id" {
  description = "Resource ID of the Log Analytics workspace."
  value       = module.this.resource_id
}

output "name" {
  description = "Name of the Log Analytics workspace."
  value       = var.name
}

output "location" {
  description = "Azure location of the Log Analytics workspace."
  value       = var.location
}

output "private_endpoints" {
  description = "Private endpoints created by the module."
  value       = module.this.private_endpoints
}
