variable "name" {
  description = "NAME OF THE BASTION HOST."
  type        = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE BASTION HOST WILL BE DEPLOYED."
  type        = string
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE BASTION HOST WILL BE DEPLOYED."
  type        = string
}

variable "sku" {
  description = "SKU OF THE BASTION HOST."
  type        = string
  default     = "Basic"

  validation {
    condition = contains([
      "Basic",
      "Developer",
      "Premium",
      "Standard"
    ], var.sku)
    error_message = "INVALID BASTION HOST SKU."
  }
}

variable "subnet_id" {
  description = "RESOURCE ID OF THE AZUREBASTIONSUBNET."
  type        = string

  validation {
    condition     = length(var.subnet_id) > 0
    error_message = "THE SUBNET ID MUST NOT BE EMPTY."
  }
}

variable "public_ip_address_id" {
  description = "RESOURCE ID OF THE PUBLIC IP ADDRESS ATTACHED TO THE BASTION HOST."
  type        = string

  validation {
    condition     = length(var.public_ip_address_id) > 0
    error_message = "THE PUBLIC IP ADDRESS ID MUST NOT BE EMPTY."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE BASTION HOST."
  type        = map(string)
  default     = {}
}