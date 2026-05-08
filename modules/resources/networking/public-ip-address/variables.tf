variable "name" {
  description = "NAME OF THE PUBLIC IP ADDRESS RESOURCE."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE PUBLIC IP ADDRESS RESOURCE WILL BE DEPLOYED."
  type        = string
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE PUBLIC IP ADDRESS RESOURCE WILL BE DEPLOYED."
  type        = string
}

variable "allocation_method" {
  description = "ALLOCATION METHOD OF THE PUBLIC IP ADDRESS RESOURCE."
  type        = string
  default     = "Static"

  validation {
    condition = contains([
      "Dynamic",
      "Static"
    ], var.allocation_method)
    error_message = "INVALID PUBLIC IP ADDRESS ALLOCATION METHOD."
  }
}

variable "sku" {
  description = "SKU OF THE PUBLIC IP ADDRESS RESOURCE."
  type        = string
  default     = "Standard"

  validation {
    condition = contains([
      "Basic",
      "Standard"
    ], var.sku)
    error_message = "INVALID PUBLIC IP ADDRESS SKU."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE PUBLIC IP ADDRESS RESOURCE."
  type        = map(string)
  default     = {}
}