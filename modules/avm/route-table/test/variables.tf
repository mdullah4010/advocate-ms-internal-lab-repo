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

variable "address_space" {
  description = "Address space assigned to the test virtual network."
  type        = list(string)
  default     = ["10.253.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Address prefix assigned to the test subnet."
  type        = string
  default     = "10.253.1.0/24"
}

variable "route_address_prefix" {
  description = "Destination address prefix for the test route."
  type        = string
  default     = "10.254.0.0/16"
}

variable "tags" {
  description = "Tags applied to the temporary test resources."
  type        = map(string)
  default = {
    environment = "test"
    managedBy   = "terraform"
    purpose     = "route-table-module-test"
  }
}