variable "org_code" {
  description = "Approved organization code used by the example module calls."
  type        = string
}

variable "organization_codes" {
  description = "Controlled organization-code registry containing org_code."
  type        = set(string)
}

variable "purpose_codes" {
  description = "Controlled purpose-code registry used by the examples."
  type        = set(string)
  default     = ["connect", "firewall", "tfstate"]
}

variable "region_code" {
  description = "Approved Azure region code used by regional examples."
  type        = string
  default     = "eus2"
}

variable "environment_code" {
  description = "Approved Advocate Health cloud and environment code."
  type        = string
  default     = "azp"
}

variable "instance" {
  description = "Instance number used by generated resource names."
  type        = number
  default     = 1
}
