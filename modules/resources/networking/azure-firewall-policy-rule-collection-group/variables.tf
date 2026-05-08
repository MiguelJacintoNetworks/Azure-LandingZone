variable "name" {
  description = "NAME OF THE AZURE FIREWALL POLICY RULE COLLECTION GROUP."
  type        = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "THE NAME MUST NOT BE EMPTY."
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

variable "priority" {
  description = "PRIORITY OF THE AZURE FIREWALL POLICY RULE COLLECTION GROUP."
  type        = number

  validation {
    condition     = var.priority >= 100 && var.priority <= 65000
    error_message = "THE PRIORITY MUST BE BETWEEN 100 AND 65000."
  }
}

variable "network_rule_collections" {
  description = "LIST OF NETWORK RULE COLLECTIONS TO CREATE IN THE AZURE FIREWALL POLICY RULE COLLECTION GROUP."

  type = list(object({
    name     = string
    priority = number
    action   = string
    rules = list(object({
      name                  = string
      protocols             = list(string)
      source_addresses      = list(string)
      destination_addresses = optional(list(string))
      destination_fqdns     = optional(list(string))
      destination_ports     = list(string)
    }))
  }))

  default = []

  validation {
    condition = alltrue([
      for collection in var.network_rule_collections :
      length(collection.name) > 0 &&
      collection.priority >= 100 &&
      collection.priority <= 65000 &&
      contains(["Allow", "Deny"], collection.action)
    ])
    error_message = "ALL NETWORK RULE COLLECTIONS MUST HAVE A VALID NAME, PRIORITY, AND ACTION."
  }
}

variable "application_rule_collections" {
  description = "LIST OF APPLICATION RULE COLLECTIONS TO CREATE IN THE AZURE FIREWALL POLICY RULE COLLECTION GROUP."

  type = list(object({
    name     = string
    priority = number
    action   = string
    rules = list(object({
      name              = string
      source_addresses  = list(string)
      destination_fqdns = list(string)
      protocols = list(object({
        type = string
        port = number
      }))
    }))
  }))

  default = []

  validation {
    condition = alltrue([
      for collection in var.application_rule_collections :
      length(collection.name) > 0 &&
      collection.priority >= 100 &&
      collection.priority <= 65000 &&
      contains(["Allow", "Deny"], collection.action)
    ])
    error_message = "ALL APPLICATION RULE COLLECTIONS MUST HAVE A VALID NAME, PRIORITY, AND ACTION."
  }
}

variable "nat_rule_collections" {
  description = "LIST OF NAT RULE COLLECTIONS TO CREATE IN THE AZURE FIREWALL POLICY RULE COLLECTION GROUP."

  type = list(object({
    name     = string
    priority = number
    action   = string
    rules = list(object({
      name                = string
      protocols           = list(string)
      source_addresses    = list(string)
      destination_address = string
      destination_ports   = list(string)
      translated_address  = string
      translated_port     = string
    }))
  }))

  default = []

  validation {
    condition = alltrue([
      for collection in var.nat_rule_collections :
      length(collection.name) > 0 &&
      collection.priority >= 100 &&
      collection.priority <= 65000 &&
      contains(["Dnat", "dnat"], collection.action)
    ])
    error_message = "ALL NAT RULE COLLECTIONS MUST HAVE A VALID NAME, PRIORITY, AND ACTION."
  }
}