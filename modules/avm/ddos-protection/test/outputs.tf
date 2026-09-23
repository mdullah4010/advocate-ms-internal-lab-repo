output "resource_group_id" {
	description = "Resource ID of the temporary test resource group."
	value       = module.resource_group.id
}

output "resource_group_name" {
	description = "Name of the temporary test resource group."
	value       = module.resource_group.name
}

output "ddos_protection_plan_id" {
	description = "Resource ID of the test DDoS protection plan."
	value       = module.ddos_protection.id
}

output "ddos_protection_plan_name" {
	description = "Name of the test DDoS protection plan."
	value       = module.ddos_protection.name
}
