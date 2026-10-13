output "resource" {
  description = "Full Event Hubs namespace resource output."
  sensitive   = true
  value       = module.this.resource
}

output "resource_id" {
  description = "Resource ID of the Event Hubs namespace."
  value       = module.this.resource_id
}

output "event_hubs" {
  description = "Event Hubs created by the module, keyed by the supplied event hub names."
  value       = module.this.resource_eventhubs
}

output "private_endpoints" {
  description = "Private endpoints created by the module."
  value       = module.this.private_endpoints
}

output "name" {
  description = "Name of the Event Hubs namespace."
  value       = var.name
}

output "location" {
  description = "Azure location of the Event Hubs namespace."
  value       = var.location
}
