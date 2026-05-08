variable "location" {
  description = "AZURE REGION OF THE MAINTENANCE ASSIGNMENT."
  type        = string
}

variable "maintenance_configuration_id" {
  description = "RESOURCE ID OF THE MAINTENANCE CONFIGURATION."
  type        = string

  validation {
    condition     = length(var.maintenance_configuration_id) > 0
    error_message = "THE MAINTENANCE CONFIGURATION ID MUST NOT BE EMPTY."
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