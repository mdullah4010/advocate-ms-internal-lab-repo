output "dns_name" {
  description = "The DNS name of the Azure Bastion resource."
  value       = module.this.dns_name
}
output "name" {
  description = "The name of the Azure Bastion resource."
  value       = module.this.name
}
output "resource" {
  description = "The Azure Bastion resource."
  value       = module.this.resource
}
output "resource_id" {
  description = "The resource ID of the Azure Bastion resource."
  value       = module.this.resource_id
}