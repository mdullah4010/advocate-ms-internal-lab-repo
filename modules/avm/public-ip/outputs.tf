output "public_ip_id" {
  description = "The ID of the created public IP address"
  value       = module.this.resource_id
}

output "name" {
  description = "The name of the created public IP address"
  value       = module.this.name
}

output "public_ip_address" {
  description = "The assigned IP address of the public IP"
  value       = module.this.public_ip_address
}

output "resource_id" {
  description = "Resource ID of the public IP address."
  value       = module.this.resource_id
}