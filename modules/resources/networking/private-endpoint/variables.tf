variable "name" {
  description = "NAME OF THE PRIVATE ENDPOINT."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE PRIVATE ENDPOINT WILL BE DEPLOYED."
  type        = string
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE PRIVATE ENDPOINT WILL BE DEPLOYED."
  type        = string
}

variable "subnet_id" {
  description = "RESOURCE ID OF THE SUBNET USED BY THE PRIVATE ENDPOINT."
  type        = string

  validation {
    condition     = length(var.subnet_id) > 0
    error_message = "THE SUBNET ID MUST NOT BE EMPTY."
  }
}

variable "private_connection_resource_id" {
  description = "RESOURCE ID OF THE TARGET RESOURCE EXPOSED THROUGH THE PRIVATE ENDPOINT."
  type        = string

  validation {
    condition     = length(var.private_connection_resource_id) > 0
    error_message = "THE PRIVATE CONNECTION RESOURCE ID MUST NOT BE EMPTY."
  }
}

variable "subresource_names" {
  description = "LIST OF SUBRESOURCE NAMES EXPOSED THROUGH THE PRIVATE ENDPOINT."
  type        = list(string)

  validation {
    condition     = length(var.subresource_names) > 0
    error_message = "AT LEAST ONE SUBRESOURCE NAME MUST BE PROVIDED."
  }
}

variable "private_service_connection_name" {
  description = "NAME OF THE PRIVATE SERVICE CONNECTION."
  type        = string

  validation {
    condition     = length(var.private_service_connection_name) > 0
    error_message = "THE PRIVATE SERVICE CONNECTION NAME MUST NOT BE EMPTY."
  }
}

variable "private_dns_zone_ids" {
  description = "LIST OF RESOURCE IDS OF THE PRIVATE DNS ZONES LINKED TO THE PRIVATE ENDPOINT."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for id in var.private_dns_zone_ids : length(id) > 0
    ])
    error_message = "ALL PRIVATE DNS ZONE IDS MUST BE NON-EMPTY."
  }
}

variable "private_dns_zone_group_name" {
  description = "NAME OF THE PRIVATE DNS ZONE GROUP LINKED TO THE PRIVATE ENDPOINT."
  type        = string
  default     = "default"

  validation {
    condition     = length(var.private_dns_zone_group_name) > 0
    error_message = "THE PRIVATE DNS ZONE GROUP NAME MUST NOT BE EMPTY."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE PRIVATE ENDPOINT."
  type        = map(string)
  default     = {}
}