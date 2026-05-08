variable "name" {
  description = "NAME OF THE NETWORK SECURITY GROUP."
  type        = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE NETWORK SECURITY GROUP WILL BE DEPLOYED."
  type        = string
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE NETWORK SECURITY GROUP WILL BE DEPLOYED."
  type        = string
}

variable "security_rules" {
  description = "MAP OF SECURITY RULE DEFINITIONS APPLIED TO THE NETWORK SECURITY GROUP."

  type = map(object({
    name                         = string
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_range            = optional(string)
    destination_port_range       = optional(string)
    source_port_ranges           = optional(list(string))
    destination_port_ranges      = optional(list(string))
    source_address_prefix        = optional(string)
    destination_address_prefix   = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_address_prefixes = optional(list(string))
    description                  = optional(string)
  }))

  default = {}

  validation {
    condition = alltrue([
      for rule in values(var.security_rules) :
      length(rule.name) > 0 &&
      rule.priority >= 100 &&
      rule.priority <= 4096 &&
      contains(["Inbound", "Outbound"], rule.direction) &&
      contains(["Allow", "Deny"], rule.access)
    ])
    error_message = "ALL SECURITY RULES MUST HAVE A VALID NAME, PRIORITY, DIRECTION, AND ACCESS VALUE."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE NETWORK SECURITY GROUP."
  type        = map(string)
  default     = {}
}