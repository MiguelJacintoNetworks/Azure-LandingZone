variable "name" {
  description = "NAME OF THE PRIVATE DNS ZONE VIRTUAL NETWORK LINK."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE PRIVATE DNS ZONE EXISTS."
  type        = string
}

variable "private_dns_zone_name" {
  description = "NAME OF THE PRIVATE DNS ZONE."
  type        = string

  validation {
    condition     = length(var.private_dns_zone_name) > 0
    error_message = "THE PRIVATE DNS ZONE NAME MUST NOT BE EMPTY."
  }
}

variable "virtual_network_id" {
  description = "RESOURCE ID OF THE VIRTUAL NETWORK TO LINK TO THE PRIVATE DNS ZONE."
  type        = string

  validation {
    condition     = length(var.virtual_network_id) > 0
    error_message = "THE VIRTUAL NETWORK ID MUST NOT BE EMPTY."
  }
}

variable "registration_enabled" {
  description = "WHETHER AUTO-REGISTRATION IS ENABLED FOR THE LINKED VIRTUAL NETWORK."
  type        = bool
  default     = false
}

variable "tags" {
  description = "TAGS TO APPLY TO THE PRIVATE DNS ZONE VIRTUAL NETWORK LINK."
  type        = map(string)
  default     = {}
}