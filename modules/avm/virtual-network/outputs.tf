output "address_spaces" {
  description = "Address spaces of the virtual network."
  value       = module.this.address_spaces
}

output "id" {
  description = "Resource ID of the virtual network."
  value       = module.this.resource_id
}

output "name" {
  description = "Name of the virtual network."
  value       = module.this.name
}

output "peerings" {
  description = "Information about peerings created by the module."
  value       = module.this.peerings
}

output "resource" {
  description = "Azure virtual network resource."
  value       = module.this.resource
}

output "resource_id" {
  description = "Resource ID of the virtual network."
  value       = module.this.resource_id
}

output "subnets" {
  description = "Information about subnets created by the module."
  value       = module.this.subnets
}
