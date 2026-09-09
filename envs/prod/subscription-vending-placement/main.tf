resource "azurerm_subscription" "vended" {
  for_each = var.vended_subscriptions

  subscription_name = each.value.subscription_name
  alias             = each.value.alias
  billing_scope_id  = each.value.billing_scope_id
  workload          = each.value.workload
  tags              = each.value.tags

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_management_group_subscription_association" "vended" {
  for_each = var.vended_subscriptions

  management_group_id = each.value.management_group_id
  subscription_id     = "/subscriptions/${azurerm_subscription.vended[each.key].subscription_id}"
}

resource "azurerm_management_group_subscription_association" "existing" {
  for_each = local.authorized_existing_placements

  management_group_id = each.value.management_group_id
  subscription_id     = "/subscriptions/${each.value.subscription_id}"
}
