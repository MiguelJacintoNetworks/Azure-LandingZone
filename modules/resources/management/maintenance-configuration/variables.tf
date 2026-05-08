variable "name" {
  description = "NAME OF THE MAINTENANCE CONFIGURATION."
  type        = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE MAINTENANCE CONFIGURATION WILL BE DEPLOYED."
  type        = string
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE MAINTENANCE CONFIGURATION WILL BE DEPLOYED."
  type        = string
}

variable "start_date_time" {
  description = "START DATE AND TIME OF THE MAINTENANCE WINDOW."
  type        = string

  validation {
    condition     = length(var.start_date_time) > 0
    error_message = "THE START DATE AND TIME MUST NOT BE EMPTY."
  }
}

variable "duration" {
  description = "DURATION OF THE MAINTENANCE WINDOW."
  type        = string

  validation {
    condition     = length(var.duration) > 0
    error_message = "THE DURATION MUST NOT BE EMPTY."
  }
}

variable "time_zone" {
  description = "TIME ZONE OF THE MAINTENANCE WINDOW."
  type        = string

  validation {
    condition     = length(var.time_zone) > 0
    error_message = "THE TIME ZONE MUST NOT BE EMPTY."
  }
}

variable "recur_every" {
  description = "RECURRENCE EXPRESSION OF THE MAINTENANCE WINDOW."
  type        = string

  validation {
    condition     = length(var.recur_every) > 0
    error_message = "THE RECURRENCE EXPRESSION MUST NOT BE EMPTY."
  }
}

variable "reboot_setting" {
  description = "REBOOT BEHAVIOR FOR PATCH INSTALLATION."
  type        = string
  default     = "IfRequired"

  validation {
    condition = contains([
      "Always",
      "IfRequired",
      "Never"
    ], var.reboot_setting)
    error_message = "INVALID REBOOT SETTING."
  }
}

variable "windows_classifications" {
  description = "LIST OF WINDOWS UPDATE CLASSIFICATIONS INCLUDED IN THE MAINTENANCE CONFIGURATION."
  type        = list(string)
  default     = ["Critical", "Security"]

  validation {
    condition = alltrue([
      for classification in var.windows_classifications : length(classification) > 0
    ])
    error_message = "ALL WINDOWS CLASSIFICATIONS MUST BE NON-EMPTY."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE MAINTENANCE CONFIGURATION."
  type        = map(string)
  default     = {}
}