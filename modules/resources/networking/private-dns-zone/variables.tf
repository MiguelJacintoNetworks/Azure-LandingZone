variable "name" {
  description = "NAME OF THE PRIVATE DNS ZONE."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE PRIVATE DNS ZONE WILL BE DEPLOYED."
  type        = string
}

variable "tags" {
  description = "TAGS TO APPLY TO THE PRIVATE DNS ZONE."
  type        = map(string)
  default     = {}
}