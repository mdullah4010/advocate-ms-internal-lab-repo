output "resource_group_id" {
  description = "Resource ID of the temporary test resource group."
  value       = module.resource_group.id
}

output "resource_group_name" {
  description = "Name of the temporary test resource group."
  value       = module.resource_group.name
}

output "public_ip_id" {
  description = "Resource ID of the test public IP address."
  value       = module.public_ip.public_ip_id
}

output "public_ip_address" {
  description = "Allocated test public IP address."
  value       = module.public_ip.public_ip_address
}