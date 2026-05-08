variable "name" {
  description = "NAME OF THE VIRTUAL MACHINE BACKUP POLICY."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

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

variable "timezone" {
  description = "TIME ZONE OF THE VIRTUAL MACHINE BACKUP POLICY."
  type        = string
  default     = "UTC"

  validation {
    condition     = length(var.timezone) > 0
    error_message = "THE TIME ZONE MUST NOT BE EMPTY."
  }
}

variable "backup_frequency" {
  description = "BACKUP FREQUENCY OF THE VIRTUAL MACHINE BACKUP POLICY."
  type        = string
  default     = "Daily"

  validation {
    condition = contains([
      "Daily",
      "Weekly"
    ], var.backup_frequency)
    error_message = "INVALID BACKUP FREQUENCY."
  }
}

variable "backup_time" {
  description = "BACKUP TIME OF THE VIRTUAL MACHINE BACKUP POLICY IN HH:MM FORMAT."
  type        = string
  default     = "23:00"

  validation {
    condition     = can(regex("^([01][0-9]|2[0-3]):[0-5][0-9]$", var.backup_time))
    error_message = "THE BACKUP TIME MUST BE IN HH:MM FORMAT."
  }
}

variable "retention_daily_count" {
  description = "NUMBER OF DAILY RECOVERY POINTS TO RETAIN."
  type        = number
  default     = 7

  validation {
    condition     = var.retention_daily_count >= 1
    error_message = "THE RETENTION DAILY COUNT MUST BE GREATER THAN OR EQUAL TO 1."
  }
}