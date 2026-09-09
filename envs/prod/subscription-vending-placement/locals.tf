locals {
  authorized_existing_placements = {
    for key, placement in var.existing_subscription_placements : key => placement
    if placement.move_authorized
  }
}
