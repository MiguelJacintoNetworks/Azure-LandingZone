variable "name" {
  description = "NAME OF THE VIRTUAL NETWORK PEERING."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP OF THE SOURCE VIRTUAL NETWORK."
  type        = string
}

variable "virtual_network_name" {
  description = "NAME OF THE SOURCE VIRTUAL NETWORK."
  type        = string

  validation {
    condition     = length(var.virtual_network_name) > 0
    error_message = "THE VIRTUAL NETWORK NAME MUST NOT BE EMPTY."
  }
}

variable "remote_virtual_network_id" {
  description = "RESOURCE ID OF THE REMOTE VIRTUAL NETWORK."
  type        = string

  validation {
    condition     = length(var.remote_virtual_network_id) > 0
    error_message = "THE REMOTE VIRTUAL NETWORK ID MUST NOT BE EMPTY."
  }
}

variable "allow_virtual_network_access" {
  description = "WHETHER TRAFFIC FLOW BETWEEN THE LOCAL AND REMOTE VIRTUAL NETWORKS IS ENABLED."
  type        = bool
  default     = true
}

variable "allow_forwarded_traffic" {
  description = "WHETHER FORWARDED TRAFFIC FROM THE REMOTE VIRTUAL NETWORK IS ENABLED."
  type        = bool
  default     = false
}

variable "allow_gateway_transit" {
  description = "WHETHER GATEWAY TRANSIT IS ENABLED ON THE LOCAL VIRTUAL NETWORK."
  type        = bool
  default     = false
}

variable "use_remote_gateways" {
  description = "WHETHER REMOTE GATEWAYS FROM THE PEERED VIRTUAL NETWORK ARE USED."
  type        = bool
  default     = false
}