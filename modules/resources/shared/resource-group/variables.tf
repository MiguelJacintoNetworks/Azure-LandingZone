variable "name" {
  description = "NAME OF THE RESOURCE GROUP."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 90
    error_message = "THE NAME MUST BE BETWEEN 1 AND 90 CHARACTERS."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE RESOURCE GROUP WILL BE DEPLOYED."
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "THE LOCATION MUST NOT BE EMPTY."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE RESOURCE GROUP."
  type        = map(string)
  default     = {}
}