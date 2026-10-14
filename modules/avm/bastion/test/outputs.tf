output "bastion_dns_name" {
  description = "FQDN of the test Azure Bastion host."
  value       = module.azure_bastion.dns_name
}

output "bastion_id" {
  description = "Resource ID of the test Azure Bastion host."
  value       = module.azure_bastion.resource_id
}

output "bastion_name" {
  description = "Name of the test Azure Bastion host."
  value       = module.azure_bastion.name
}

output "resource_group_id" {
  description = "Resource ID of the temporary test resource group."
  value       = module.resource_group.id
}

output "subnets" {
  description = "Subnets created for the Azure Bastion host."
  value       = module.virtual_network.subnets
}

output "virtual_network_id" {
  description = "Resource ID of the test virtual network."
  value       = module.virtual_network.id
}
