variable "name" {
  description = "NAME OF THE LOG ANALYTICS WORKSPACE."
  type        = string

  validation {
    condition     = length(var.name) >= 4 && length(var.name) <= 63
    error_message = "THE NAME MUST BE BETWEEN 4 AND 63 CHARACTERS."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE LOG ANALYTICS WORKSPACE WILL BE DEPLOYED."
  type        = string
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE LOG ANALYTICS WORKSPACE WILL BE DEPLOYED."
  type        = string
}

variable "sku" {
  description = "SKU OF THE LOG ANALYTICS WORKSPACE."
  type        = string

  validation {
    condition = contains([
      "CapacityReservation",
      "Free",
      "LACluster",
      "PerGB2018",
      "PerNode",
      "Premium",
      "Standalone",
      "Standard",
      "Unlimited"
    ], var.sku)
    error_message = "INVALID LOG ANALYTICS WORKSPACE SKU."
  }
}

variable "retention_in_days" {
  description = "RETENTION PERIOD IN DAYS FOR THE LOG ANALYTICS WORKSPACE."
  type        = number

  validation {
    condition     = var.retention_in_days >= 7
    error_message = "THE RETENTION PERIOD MUST BE GREATER THAN OR EQUAL TO 7 DAYS."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE LOG ANALYTICS WORKSPACE."
  type        = map(string)
  default     = {}
}