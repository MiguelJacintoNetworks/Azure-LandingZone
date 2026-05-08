variable "name" {
  description = "NAME OF THE AZURE FIREWALL POLICY."
  type        = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE AZURE FIREWALL POLICY WILL BE DEPLOYED."
  type        = string
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE AZURE FIREWALL POLICY WILL BE DEPLOYED."
  type        = string
}

variable "sku" {
  description = "SKU OF THE AZURE FIREWALL POLICY."
  type        = string
  default     = "Standard"

  validation {
    condition = contains([
      "Basic",
      "Premium",
      "Standard"
    ], var.sku)
    error_message = "INVALID AZURE FIREWALL POLICY SKU."
  }
}

variable "threat_intelligence_mode" {
  description = "THREAT INTELLIGENCE MODE OF THE AZURE FIREWALL POLICY."
  type        = string
  default     = "Alert"

  validation {
    condition = contains([
      "Alert",
      "Deny",
      "Off"
    ], var.threat_intelligence_mode)
    error_message = "INVALID THREAT INTELLIGENCE MODE."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE AZURE FIREWALL POLICY."
  type        = map(string)
  default     = {}
}