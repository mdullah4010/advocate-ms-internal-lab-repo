output "resource_group_id" {
  description = "Resource ID of the temporary test resource group."
  value       = module.resource_group.id
}

output "resource_group_name" {
  description = "Name of the temporary test resource group."
  value       = module.resource_group.name
}

output "event_hub_namespace_id" {
  description = "Resource ID of the test Event Hubs namespace."
  value       = module.event_hub.resource_id
}

output "event_hub_namespace_name" {
  description = "Name of the test Event Hubs namespace."
  value       = module.event_hub.name
}

output "event_hubs" {
  description = "Event Hubs created for the test deployment."
  value       = module.event_hub.event_hubs
}
