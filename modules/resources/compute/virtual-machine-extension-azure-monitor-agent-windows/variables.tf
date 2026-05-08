variable "name" {
  description = "NAME OF THE VIRTUAL MACHINE EXTENSION."
  type        = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "virtual_machine_id" {
  description = "RESOURCE ID OF THE TARGET VIRTUAL MACHINE."
  type        = string
}

variable "publisher" {
  description = "PUBLISHER OF THE VIRTUAL MACHINE EXTENSION."
  type        = string
  default     = "Microsoft.Azure.Monitor"
}

variable "type" {
  description = "TYPE OF THE VIRTUAL MACHINE EXTENSION."
  type        = string
  default     = "AzureMonitorWindowsAgent"
}

variable "type_handler_version" {
  description = "TYPE HANDLER VERSION OF THE VIRTUAL MACHINE EXTENSION."
  type        = string
  default     = "1.0"
}

variable "auto_upgrade_minor_version" {
  description = "WHETHER MINOR VERSION UPGRADES ARE APPLIED AUTOMATICALLY."
  type        = bool
  default     = true
}

variable "automatic_upgrade_enabled" {
  description = "WHETHER AUTOMATIC UPGRADES ARE ENABLED FOR THE VIRTUAL MACHINE EXTENSION."
  type        = bool
  default     = true
}