variable "name" {
  description = "NAME OF THE CUSTOM SCRIPT VIRTUAL MACHINE EXTENSION."
  type        = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "virtual_machine_id" {
  description = "RESOURCE ID OF THE TARGET VIRTUAL MACHINE."
  type        = string

  validation {
    condition     = length(var.virtual_machine_id) > 0
    error_message = "THE VIRTUAL MACHINE ID MUST NOT BE EMPTY."
  }
}

variable "type_handler_version" {
  description = "TYPE HANDLER VERSION OF THE CUSTOM SCRIPT EXTENSION."
  type        = string
  default     = "1.10"
}

variable "auto_upgrade_minor_version" {
  description = "WHETHER MINOR VERSION UPGRADES ARE APPLIED AUTOMATICALLY."
  type        = bool
  default     = true
}

variable "settings" {
  description = "PUBLIC SETTINGS JSON OF THE CUSTOM SCRIPT EXTENSION."
  type        = string

  validation {
    condition     = length(trimspace(var.settings)) > 0
    error_message = "THE SETTINGS JSON MUST NOT BE EMPTY."
  }
}

variable "protected_settings" {
  description = "PROTECTED SETTINGS JSON OF THE CUSTOM SCRIPT EXTENSION."
  type        = string

  validation {
    condition     = length(trimspace(var.protected_settings)) > 0
    error_message = "THE PROTECTED SETTINGS JSON MUST NOT BE EMPTY."
  }
}