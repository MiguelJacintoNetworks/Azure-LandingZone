variable "tier" {
  description = "PRICING TIER OF THE MICROSOFT DEFENDER FOR CLOUD PLAN."
  type        = string
  default     = "Standard"

  validation {
    condition = contains([
      "Free",
      "Standard"
    ], var.tier)
    error_message = "INVALID PRICING TIER."
  }
}

variable "resource_type" {
  description = "RESOURCE TYPE OF THE MICROSOFT DEFENDER FOR CLOUD PLAN."
  type        = string

  validation {
    condition     = length(var.resource_type) > 0
    error_message = "THE RESOURCE TYPE MUST NOT BE EMPTY."
  }
}

variable "subplan" {
  description = "SUBPLAN OF THE MICROSOFT DEFENDER FOR CLOUD SUBSCRIPTION PRICING CONFIGURATION."
  type        = string
  default     = "P2"

  validation {
    condition     = length(var.subplan) > 0
    error_message = "THE SUBPLAN MUST NOT BE EMPTY."
  }
}