variable "name" {
  description = "NAME OF THE RECOVERY SERVICES VAULT."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE RECOVERY SERVICES VAULT WILL BE DEPLOYED."
  type        = string
}

variable "resource_group_id" {
  description = "RESOURCE ID OF THE RESOURCE GROUP WHERE THE RECOVERY SERVICES VAULT WILL BE DEPLOYED."
  type        = string

  validation {
    condition     = length(var.resource_group_id) > 0
    error_message = "THE RESOURCE GROUP ID MUST NOT BE EMPTY."
  }
}

variable "sku" {
  description = "SKU OF THE RECOVERY SERVICES VAULT."
  type        = string
  default     = "Standard"

  validation {
    condition = contains([
      "RS0",
      "Standard"
    ], var.sku)
    error_message = "INVALID RECOVERY SERVICES VAULT SKU."
  }
}

variable "public_network_access" {
  description = "PUBLIC NETWORK ACCESS SETTING OF THE RECOVERY SERVICES VAULT."
  type        = string
  default     = "Enabled"

  validation {
    condition = contains([
      "Disabled",
      "Enabled"
    ], var.public_network_access)
    error_message = "INVALID PUBLIC NETWORK ACCESS VALUE."
  }
}

variable "immutability_state" {
  description = "IMMUTABILITY STATE OF THE RECOVERY SERVICES VAULT."
  type        = string
  default     = "Disabled"

  validation {
    condition = contains([
      "Disabled",
      "Locked",
      "Unlocked"
    ], var.immutability_state)
    error_message = "INVALID IMMUTABILITY STATE."
  }
}

variable "soft_delete_state" {
  description = "SOFT DELETE STATE OF THE RECOVERY SERVICES VAULT."
  type        = string
  default     = "Enabled"

  validation {
    condition = contains([
      "AlwaysON",
      "Disabled",
      "Enabled"
    ], var.soft_delete_state)
    error_message = "INVALID SOFT DELETE STATE."
  }
}

variable "soft_delete_retention_period_in_days" {
  description = "SOFT DELETE RETENTION PERIOD IN DAYS FOR THE RECOVERY SERVICES VAULT."
  type        = number
  default     = 14

  validation {
    condition     = var.soft_delete_retention_period_in_days >= 1
    error_message = "THE SOFT DELETE RETENTION PERIOD IN DAYS MUST BE GREATER THAN OR EQUAL TO 1."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE RECOVERY SERVICES VAULT."
  type        = map(string)
  default     = {}
}