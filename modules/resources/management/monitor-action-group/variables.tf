variable "name" {
  description = "NAME OF THE ACTION GROUP."
  type        = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE ACTION GROUP WILL BE DEPLOYED."
  type        = string
}

variable "short_name" {
  description = "SHORT NAME OF THE ACTION GROUP."
  type        = string

  validation {
    condition     = length(var.short_name) >= 1 && length(var.short_name) <= 12
    error_message = "THE SHORT NAME MUST BE BETWEEN 1 AND 12 CHARACTERS."
  }
}

variable "email_receiver_name" {
  description = "NAME OF THE EMAIL RECEIVER."
  type        = string

  validation {
    condition     = length(var.email_receiver_name) >= 1
    error_message = "THE EMAIL RECEIVER NAME MUST NOT BE EMPTY."
  }
}

variable "email_receiver_address" {
  description = "EMAIL ADDRESS OF THE ACTION GROUP RECEIVER."
  type        = string

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.email_receiver_address))
    error_message = "THE EMAIL RECEIVER ADDRESS MUST BE A VALID EMAIL ADDRESS."
  }
}

variable "use_common_alert_schema" {
  description = "WHETHER THE COMMON ALERT SCHEMA IS ENABLED FOR THE EMAIL RECEIVER."
  type        = bool
  default     = true
}

variable "tags" {
  description = "TAGS TO APPLY TO THE ACTION GROUP."
  type        = map(string)
  default     = {}
}