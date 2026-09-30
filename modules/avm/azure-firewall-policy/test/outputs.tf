output "firewall_policy_id" {
  description = "Resource ID of the test Firewall Policy."
  value       = module.firewall_policy.resource_id
}

output "rule_collection_group_ids" {
  description = "Resource IDs of the test Firewall Policy Rule Collection Groups."
  value       = module.firewall_policy.rule_collection_group_ids
}

output "resource_group_id" {
  description = "Resource ID of the temporary test Resource Group."
  value       = module.resource_group.id
}

output "resource_group_name" {
  description = "Name of the temporary test Resource Group."
  value       = module.resource_group.name
}