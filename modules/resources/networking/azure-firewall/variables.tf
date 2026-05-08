variable "name" {
  description = "NAME OF THE AZURE FIREWALL."
  type        = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE AZURE FIREWALL WILL BE DEPLOYED."
  type        = string
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE AZURE FIREWALL WILL BE DEPLOYED."
  type        = string
}

variable "subnet_id" {
  description = "RESOURCE ID OF THE AZUREFIREWALLSUBNET."
  type        = string

  validation {
    condition     = length(var.subnet_id) > 0
    error_message = "THE SUBNET ID MUST NOT BE EMPTY."
  }
}

variable "public_ip_address_id" {
  description = "RESOURCE ID OF THE PUBLIC IP ADDRESS ATTACHED TO THE AZURE FIREWALL."
  type        = string

  validation {
    condition     = length(var.public_ip_address_id) > 0
    error_message = "THE PUBLIC IP ADDRESS ID MUST NOT BE EMPTY."
  }
}

variable "firewall_policy_id" {
  description = "RESOURCE ID OF THE AZURE FIREWALL POLICY."
  type        = string

  validation {
    condition     = length(var.firewall_policy_id) > 0
    error_message = "THE FIREWALL POLICY ID MUST NOT BE EMPTY."
  }
}

variable "sku_name" {
  description = "SKU NAME OF THE AZURE FIREWALL."
  type        = string
  default     = "AZFW_VNet"

  validation {
    condition = contains([
      "AZFW_Hub",
      "AZFW_VNet"
    ], var.sku_name)
    error_message = "INVALID AZURE FIREWALL SKU NAME."
  }
}

variable "sku_tier" {
  description = "SKU TIER OF THE AZURE FIREWALL."
  type        = string
  default     = "Standard"

  validation {
    condition = contains([
      "Basic",
      "Premium",
      "Standard"
    ], var.sku_tier)
    error_message = "INVALID AZURE FIREWALL SKU TIER."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE AZURE FIREWALL."
  type        = map(string)
  default     = {}
}