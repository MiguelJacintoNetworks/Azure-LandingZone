variable "name" {
  description = "NAME OF THE KEY VAULT."
  type        = string

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 24 && can(regex("^[a-zA-Z0-9-]+$", var.name))
    error_message = "THE NAME MUST BE BETWEEN 3 AND 24 CHARACTERS AND CONTAIN ONLY LETTERS, NUMBERS, AND HYPHENS."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE KEY VAULT WILL BE DEPLOYED."
  type        = string
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE KEY VAULT WILL BE DEPLOYED."
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "THE RESOURCE GROUP NAME MUST NOT BE EMPTY."
  }
}

variable "tenant_id" {
  description = "AZURE TENANT ID USED BY THE KEY VAULT."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.tenant_id))
    error_message = "THE TENANT ID MUST BE A VALID GUID."
  }
}

variable "sku_name" {
  description = "SKU OF THE KEY VAULT."
  type        = string
  default     = "standard"

  validation {
    condition = contains([
      "premium",
      "standard"
    ], var.sku_name)
    error_message = "INVALID KEY VAULT SKU."
  }
}

variable "public_network_access_enabled" {
  description = "WHETHER PUBLIC NETWORK ACCESS IS ENABLED FOR THE KEY VAULT."
  type        = bool
  default     = false
}

variable "purge_protection_enabled" {
  description = "WHETHER PURGE PROTECTION IS ENABLED FOR THE KEY VAULT."
  type        = bool
  default     = true
}

variable "soft_delete_retention_days" {
  description = "SOFT DELETE RETENTION PERIOD IN DAYS FOR THE KEY VAULT."
  type        = number
  default     = 90

  validation {
    condition     = var.soft_delete_retention_days >= 7 && var.soft_delete_retention_days <= 90
    error_message = "THE SOFT DELETE RETENTION PERIOD MUST BE BETWEEN 7 AND 90 DAYS."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE KEY VAULT."
  type        = map(string)
  default     = {}
}

variable "rbac_authorization_enabled" {
  description = "WHETHER AZURE RBAC IS USED FOR KEY VAULT DATA PLANE AUTHORIZATION."
  type        = bool
  default     = true
}