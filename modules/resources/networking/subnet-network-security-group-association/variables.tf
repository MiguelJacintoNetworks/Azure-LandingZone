variable "subnet_id" {
  description = "RESOURCE ID OF THE SUBNET."
  type        = string

  validation {
    condition     = length(var.subnet_id) > 0
    error_message = "THE SUBNET ID MUST NOT BE EMPTY."
  }
}

variable "network_security_group_id" {
  description = "RESOURCE ID OF THE NETWORK SECURITY GROUP."
  type        = string

  validation {
    condition     = length(var.network_security_group_id) > 0
    error_message = "THE NETWORK SECURITY GROUP ID MUST NOT BE EMPTY."
  }
}