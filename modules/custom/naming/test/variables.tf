variable "org_code" {
  description = "Approved organization code used by the example module calls."
  type        = string
  default     = "se"
}

variable "region_code" {
  description = "Approved Azure region code used by regional examples."
  type        = string
  default     = "eus2"
}

variable "environment_code" {
  description = "Approved Advocate Health cloud and environment code."
  type        = string
  default     = "prd"
}

variable "instance" {
  description = "Instance number used by generated resource names."
  type        = number
  default     = 1
}
