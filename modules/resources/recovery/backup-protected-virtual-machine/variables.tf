variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE RECOVERY SERVICES VAULT EXISTS."
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "THE RESOURCE GROUP NAME MUST NOT BE EMPTY."
  }
}

variable "recovery_vault_name" {
  description = "NAME OF THE RECOVERY SERVICES VAULT."
  type        = string

  validation {
    condition     = length(var.recovery_vault_name) > 0
    error_message = "THE RECOVERY SERVICES VAULT NAME MUST NOT BE EMPTY."
  }
}

variable "virtual_machine_id" {
  description = "RESOURCE ID OF THE VIRTUAL MACHINE TO PROTECT."
  type        = string

  validation {
    condition     = length(var.virtual_machine_id) > 0
    error_message = "THE VIRTUAL MACHINE ID MUST NOT BE EMPTY."
  }
}

variable "backup_policy_id" {
  description = "RESOURCE ID OF THE BACKUP POLICY APPLIED TO THE VIRTUAL MACHINE."
  type        = string

  validation {
    condition     = length(var.backup_policy_id) > 0
    error_message = "THE BACKUP POLICY ID MUST NOT BE EMPTY."
  }
}