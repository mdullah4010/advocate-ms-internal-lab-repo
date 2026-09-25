output "forwarding_rulesets" {
  description = "Forwarding rulesets created for the test private DNS resolver."
  value       = module.private_dns_resolver.forwarding_rulesets
}

output "inbound_endpoint_ips" {
  description = "IP addresses assigned to the test inbound endpoints."
  value       = module.private_dns_resolver.inbound_endpoint_ips
}

output "inbound_endpoints" {
  description = "Inbound endpoints created for the test private DNS resolver."
  value       = module.private_dns_resolver.inbound_endpoints
}

output "outbound_endpoints" {
  description = "Outbound endpoints created for the test private DNS resolver."
  value       = module.private_dns_resolver.outbound_endpoints
}

output "private_dns_resolver_id" {
  description = "Resource ID of the test private DNS resolver."
  value       = module.private_dns_resolver.resource_id
}

output "private_dns_resolver_name" {
  description = "Name of the test private DNS resolver."
  value       = module.private_dns_resolver.name
}

output "resource_group_id" {
  description = "Resource ID of the temporary test resource group."
  value       = module.resource_group.id
}

output "virtual_network_id" {
  description = "Resource ID of the test virtual network."
  value       = module.virtual_network.id
}

output "subnets" {
  description = "Subnets created for the private DNS resolver endpoints."
  value       = module.virtual_network.subnets
}
