variable "tenant_id" {
  description = "Microsoft Entra tenant ID used for the test deployment."
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID used for the test deployment."
  type        = string
}

variable "location" {
  description = "Azure region for the test resources."
  type        = string
  default     = "westus3"
}

variable "test_run_id" {
  description = "Unique identifier appended to temporary resource names."
  type        = string
}

variable "allocation_method" {
  description = "Allocation method used by the test public IP address."
  type        = string
  default     = "Static"
}

variable "sku" {
  description = "SKU used by the test public IP address."
  type        = string
  default     = "Standard"
}

variable "sku_tier" {
  description = "SKU tier used by the test public IP address."
  type        = string
  default     = "Regional"
}

variable "tags" {
  description = "Tags applied to the temporary test resources."
  type        = map(string)
  default = {
    environment = "test"
    managedBy   = "terraform"
    purpose     = "public-ip-module-test"
  }
}

variable "ddos_protection_mode" {
  description = "DDoS protection mode for the public IP address."
  type        = string
  default     = "VirtualNetworkInherited"

  validation {
    condition     = var.ddos_protection_mode == null || contains(["Enabled", "Disabled"], var.ddos_protection_mode)
    error_message = "ddos_protection_mode must be Enabled, Disabled, or null."
  }
}