variable "display_name" {
  description = "DISPLAY NAME OF THE MICROSOFT ENTRA ID GROUP."
  type        = string

  validation {
    condition     = length(var.display_name) >= 1
    error_message = "THE DISPLAY NAME MUST NOT BE EMPTY."
  }
}

variable "description" {
  description = "DESCRIPTION OF THE MICROSOFT ENTRA ID GROUP."
  type        = string

  validation {
    condition     = length(var.description) >= 1
    error_message = "THE DESCRIPTION MUST NOT BE EMPTY."
  }
}

variable "mail_nickname" {
  description = "MAIL NICKNAME OF THE MICROSOFT ENTRA ID GROUP."
  type        = string

  validation {
    condition     = length(var.mail_nickname) >= 1
    error_message = "THE MAIL NICKNAME MUST NOT BE EMPTY."
  }
}

variable "member_object_ids" {
  description = "LIST OF MICROSOFT ENTRA OBJECT IDS TO ADD AS MEMBERS."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for id in var.member_object_ids :
      can(regex("^[0-9a-fA-F-]{36}$", id))
    ])
    error_message = "ALL MEMBER OBJECT IDS MUST BE VALID GUIDS."
  }
}