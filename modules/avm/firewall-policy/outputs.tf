output "resource" {
  description = "Full Azure Firewall Policy resource output."
  value       = module.this.resource
}

output "resource_id" {
  description = "Resource ID of the Azure Firewall Policy."
  value       = module.this.resource_id
}

output "rule_collection_groups" {
  description = "Full resources for the configured Firewall Policy Rule Collection Groups, keyed by input map key."
  value       = { for key, group in module.rule_collection_group : key => group.resource }
}

output "rule_collection_group_ids" {
  description = "Resource IDs for the configured Firewall Policy Rule Collection Groups, keyed by input map key."
  value       = { for key, group in module.rule_collection_group : key => group.resource_id }
}