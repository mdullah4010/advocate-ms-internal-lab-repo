resource "azurerm_resource_group" "bootstrap" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "bootstrap"
    managed-by  = "terraform"
    purpose     = "github-actions-validation"
    workload    = "landing-zone"
  }
}
