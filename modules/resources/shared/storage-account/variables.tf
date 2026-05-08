variable "name" {
  description = "NAME OF THE STORAGE ACCOUNT."
  type        = string

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 24 && can(regex("^[a-z0-9]+$", var.name))
    error_message = "THE NAME MUST BE BETWEEN 3 AND 24 CHARACTERS AND CONTAIN ONLY LOWERCASE LETTERS AND NUMBERS."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE STORAGE ACCOUNT WILL BE DEPLOYED."
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "THE LOCATION MUST NOT BE EMPTY."
  }
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE STORAGE ACCOUNT WILL BE DEPLOYED."
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "THE RESOURCE GROUP NAME MUST NOT BE EMPTY."
  }
}

variable "account_tier" {
  description = "PERFORMANCE TIER OF THE STORAGE ACCOUNT."
  type        = string
  default     = "Standard"

  validation {
    condition = contains([
      "Premium",
      "Standard"
    ], var.account_tier)
    error_message = "INVALID STORAGE ACCOUNT TIER."
  }
}

variable "account_replication_type" {
  description = "REPLICATION TYPE OF THE STORAGE ACCOUNT."
  type        = string
  default     = "LRS"

  validation {
    condition = contains([
      "GRS",
      "GZRS",
      "LRS",
      "RAGRS",
      "RAGZRS",
      "ZRS"
    ], var.account_replication_type)
    error_message = "INVALID STORAGE ACCOUNT REPLICATION TYPE."
  }
}

variable "public_network_access_enabled" {
  description = "WHETHER PUBLIC NETWORK ACCESS IS ENABLED FOR THE STORAGE ACCOUNT."
  type        = bool
  default     = false
}

variable "shared_access_key_enabled" {
  description = "WHETHER SHARED ACCESS KEY AUTHENTICATION IS ENABLED FOR THE STORAGE ACCOUNT."
  type        = bool
  default     = true
}

variable "min_tls_version" {
  description = "MINIMUM TLS VERSION ENFORCED FOR THE STORAGE ACCOUNT."
  type        = string
  default     = "TLS1_2"

  validation {
    condition = contains([
      "TLS1_0",
      "TLS1_1",
      "TLS1_2"
    ], var.min_tls_version)
    error_message = "INVALID MINIMUM TLS VERSION."
  }
}

variable "allow_nested_items_to_be_public" {
  description = "WHETHER NESTED ITEMS ARE ALLOWED TO BE PUBLIC IN THE STORAGE ACCOUNT."
  type        = bool
  default     = false
}

variable "tags" {
  description = "TAGS TO APPLY TO THE STORAGE ACCOUNT."
  type        = map(string)
  default     = {}
}