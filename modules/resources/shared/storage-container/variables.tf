variable "name" {
  description = "NAME OF THE STORAGE CONTAINER."
  type        = string

  validation {
    condition     = length(var.name) >= 3 && length(var.name) <= 63 && can(regex("^[a-z0-9-]+$", var.name))
    error_message = "THE NAME MUST BE BETWEEN 3 AND 63 CHARACTERS AND CONTAIN ONLY LOWERCASE LETTERS, NUMBERS, AND HYPHENS."
  }
}

variable "storage_account_id" {
  description = "RESOURCE ID OF THE STORAGE ACCOUNT WHERE THE CONTAINER WILL BE CREATED."
  type        = string

  validation {
    condition     = length(trimspace(var.storage_account_id)) > 0
    error_message = "THE STORAGE ACCOUNT ID MUST NOT BE EMPTY."
  }
}

variable "container_access_type" {
  description = "ACCESS TYPE OF THE STORAGE CONTAINER."
  type        = string
  default     = "private"

  validation {
    condition = contains([
      "blob",
      "container",
      "private"
    ], var.container_access_type)
    error_message = "INVALID STORAGE CONTAINER ACCESS TYPE."
  }
}