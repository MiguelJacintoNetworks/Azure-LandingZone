variable "name" {
  description = "NAME OF THE ROUTE TABLE."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE ROUTE TABLE WILL BE DEPLOYED."
  type        = string
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE ROUTE TABLE WILL BE DEPLOYED."
  type        = string
}

variable "routes" {
  description = "LIST OF ROUTES TO CREATE IN THE ROUTE TABLE."

  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))

  default = []

  validation {
    condition = alltrue([
      for route in var.routes :
      length(route.name) > 0 &&
      length(route.address_prefix) > 0 &&
      length(route.next_hop_type) > 0
    ])
    error_message = "ALL ROUTES MUST HAVE A NON-EMPTY NAME, ADDRESS PREFIX, AND NEXT HOP TYPE."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE ROUTE TABLE."
  type        = map(string)
  default     = {}
}