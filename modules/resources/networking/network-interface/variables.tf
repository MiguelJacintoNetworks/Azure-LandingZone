variable "name" {
  description = "NAME OF THE NETWORK INTERFACE."
  type        = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE NETWORK INTERFACE WILL BE DEPLOYED."
  type        = string
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE NETWORK INTERFACE WILL BE DEPLOYED."
  type        = string
}

variable "subnet_id" {
  description = "RESOURCE ID OF THE SUBNET WHERE THE NETWORK INTERFACE WILL BE ATTACHED."
  type        = string

  validation {
    condition     = length(var.subnet_id) > 0
    error_message = "THE SUBNET ID MUST NOT BE EMPTY."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE NETWORK INTERFACE."
  type        = map(string)
  default     = {}
}