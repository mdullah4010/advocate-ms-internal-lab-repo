output "vended_subscription_ids" {
  description = "New subscription IDs keyed by semantic name."
  value = {
    for key, subscription in azurerm_subscription.vended : key => subscription.subscription_id
  }
}

output "authorized_existing_subscription_moves" {
  description = "Existing subscription placements authorized for this run."
  value       = keys(local.authorized_existing_placements)
}
