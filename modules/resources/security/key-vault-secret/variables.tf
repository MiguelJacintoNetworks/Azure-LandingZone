variable "name" {
  description = "NAME OF THE KEY VAULT SECRET."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 127
    error_message = "THE SECRET NAME MUST BE BETWEEN 1 AND 127 CHARACTERS."
  }
}

variable "value" {
  description = "VALUE OF THE KEY VAULT SECRET."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.value) > 0
    error_message = "THE SECRET VALUE MUST NOT BE EMPTY."
  }
}

variable "key_vault_id" {
  description = "RESOURCE ID OF THE TARGET KEY VAULT."
  type        = string

  validation {
    condition     = length(var.key_vault_id) > 0
    error_message = "THE KEY VAULT ID MUST NOT BE EMPTY."
  }
}

variable "content_type" {
  description = "CONTENT TYPE OF THE KEY VAULT SECRET."
  type        = string
  default     = null
}

variable "expiration_date" {
  description = "EXPIRATION DATE OF THE KEY VAULT SECRET IN RFC3339 FORMAT."
  type        = string
  default     = null
}

variable "not_before_date" {
  description = "NOT BEFORE DATE OF THE KEY VAULT SECRET IN RFC3339 FORMAT."
  type        = string
  default     = null
}

variable "tags" {
  description = "TAGS TO APPLY TO THE KEY VAULT SECRET."
  type        = map(string)
  default     = {}
}