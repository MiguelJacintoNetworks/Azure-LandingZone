variable "subnet_id" {
  description = "RESOURCE ID OF THE SUBNET."
  type        = string

  validation {
    condition     = length(var.subnet_id) > 0
    error_message = "THE SUBNET ID MUST NOT BE EMPTY."
  }
}

variable "route_table_id" {
  description = "RESOURCE ID OF THE ROUTE TABLE."
  type        = string

  validation {
    condition     = length(var.route_table_id) > 0
    error_message = "THE ROUTE TABLE ID MUST NOT BE EMPTY."
  }
}