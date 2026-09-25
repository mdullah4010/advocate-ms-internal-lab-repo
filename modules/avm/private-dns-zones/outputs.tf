output "a_record_outputs" {
  description = "Output for A record configuration of the private DNS zones."
  value       = module.this.a_record_outputs
}
output "aaaa_record_outputs" {
  description = "Output for AAAA record configuration of the private DNS zones."
  value       = module.this.aaaa_record_outputs
}
output "cname_record_outputs" {
  description = "Output for CNAME record configuration of the private DNS zones."
  value       = module.this.cname_record_outputs
}
output "mx_record_outputs" {
  description = "Output for MX record configuration of the private DNS zones."
  value       = module.this.mx_record_outputs
}

output "name" {
  description = "Name of Private DNS zone."
  value       = module.this.name
}
output "ptr_record_outputs" {
  description = "Output for PTR record configuration of the private DNS zones."
  value       = module.this.ptr_record_outputs
}

output "resource" {
  description = "Output for the resource configuration of the private DNS zones."
  value       = module.this.resource
}

output "resource_id" {
  description = "Output for the resource ID of the private DNS zones."
  value       = module.this.resource_id
}
output "soa_record_outputs" {
  description = "Output for SOA record configuration of the private DNS zones."
  value       = module.this.soa_record_outputs
}
output "srv_record_outputs" {
  description = "Output for SRV record configuration of the private DNS zones."
  value       = module.this.srv_record_outputs
}
output "txt_record_outputs" {
  description = "Output for TXT record configuration of the private DNS zones."
  value       = module.this.txt_record_outputs
}
output "virtual_network_links_outputs" {
  description = "Output for virtual network links configuration of the private DNS zones."
  value       = module.this.virtual_network_link_outputs
}