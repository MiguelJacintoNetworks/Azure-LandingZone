variable "name" {
  description = "NAME OF THE VIRTUAL NETWORK."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE VIRTUAL NETWORK WILL BE DEPLOYED."
  type        = string
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE VIRTUAL NETWORK WILL BE DEPLOYED."
  type        = string
}

variable "address_space" {
  description = "ADDRESS SPACE OF THE VIRTUAL NETWORK."
  type        = list(string)

  validation {
    condition     = length(var.address_space) > 0
    error_message = "AT LEAST ONE ADDRESS SPACE PREFIX MUST BE PROVIDED."
  }
}

variable "subnets" {
  description = "MAP OF SUBNET DEFINITIONS TO CREATE WITHIN THE VIRTUAL NETWORK."

  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))

  default = {}

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) :
      length(subnet.name) > 0 && length(subnet.address_prefixes) > 0
    ])
    error_message = "ALL SUBNET DEFINITIONS MUST HAVE A NON-EMPTY NAME AND AT LEAST ONE ADDRESS PREFIX."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE VIRTUAL NETWORK."
  type        = map(string)
  default     = {}
}