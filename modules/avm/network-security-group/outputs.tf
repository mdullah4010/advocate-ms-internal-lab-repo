output "id" {
  description = "Resource ID of the network security group."
  value       = module.this.resource_id
}

output "name" {
  description = "Name of the network security group."
  value       = module.this.name
}

output "security_rules" {
  description = "Security rules created in the network security group."
  value       = module.this.security_rules
}