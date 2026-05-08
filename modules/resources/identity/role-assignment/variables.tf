variable "scope" {
  description = "SCOPE OF THE ROLE ASSIGNMENT."
  type        = string

  validation {
    condition     = length(var.scope) > 0
    error_message = "THE SCOPE MUST NOT BE EMPTY."
  }
}

variable "role_definition_name" {
  description = "NAME OF THE ROLE DEFINITION TO ASSIGN."
  type        = string

  validation {
    condition     = length(var.role_definition_name) > 0
    error_message = "THE ROLE DEFINITION NAME MUST NOT BE EMPTY."
  }
}

variable "principal_id" {
  description = "PRINCIPAL ID THAT RECEIVES THE ROLE ASSIGNMENT."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-fA-F-]{36}$", var.principal_id))
    error_message = "THE PRINCIPAL ID MUST BE A VALID GUID."
  }
}