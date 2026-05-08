variable "name" {
  description = "NAME OF THE MICROSOFT DEFENDER FOR CLOUD SECURITY CONTACT."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "email" {
  description = "EMAIL ADDRESS USED FOR THE MICROSOFT DEFENDER FOR CLOUD SECURITY CONTACT."
  type        = string

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.email))
    error_message = "THE EMAIL ADDRESS MUST BE VALID."
  }
}

variable "phone" {
  description = "PHONE NUMBER USED FOR THE MICROSOFT DEFENDER FOR CLOUD SECURITY CONTACT."
  type        = string
  default     = ""

  validation {
    condition     = trimspace(var.phone) == "" || can(regex("^[0-9+()\\-\\s]+$", trimspace(var.phone)))
    error_message = "THE PHONE NUMBER CONTAINS INVALID CHARACTERS."
  }
}

variable "alert_notifications" {
  description = "WHETHER ALERT NOTIFICATIONS ARE ENABLED FOR THE SECURITY CONTACT."
  type        = bool
  default     = true
}

variable "alerts_to_admins" {
  description = "WHETHER ALERT NOTIFICATIONS ARE ENABLED FOR SUBSCRIPTION ADMINS."
  type        = bool
  default     = true
}