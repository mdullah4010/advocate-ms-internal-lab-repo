output "network_security_group_id" {
  description = "Resource ID of the test network security group."
  value       = module.network_security_group.id
}

output "network_security_group_name" {
  description = "Name of the test network security group."
  value       = module.network_security_group.name
}

output "resource_group_id" {
  description = "Resource ID of the temporary test resource group."
  value       = module.resource_group.id
}

output "resource_group_name" {
  description = "Name of the temporary test resource group."
  value       = module.resource_group.name
}

output "security_rules" {
  description = "Security rules created in the test network security group."
  value       = module.network_security_group.security_rules
}