variable "name" {
  description = "NAME OF THE WINDOWS VIRTUAL MACHINE."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 64
    error_message = "THE NAME MUST BE BETWEEN 1 AND 64 CHARACTERS."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE WINDOWS VIRTUAL MACHINE WILL BE DEPLOYED."
  type        = string
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE WINDOWS VIRTUAL MACHINE WILL BE DEPLOYED."
  type        = string
}

variable "network_interface_id" {
  description = "RESOURCE ID OF THE NETWORK INTERFACE ATTACHED TO THE WINDOWS VIRTUAL MACHINE."
  type        = string
}

variable "size" {
  description = "SIZE OF THE WINDOWS VIRTUAL MACHINE."
  type        = string
}

variable "admin_username" {
  description = "ADMINISTRATOR USERNAME FOR THE WINDOWS VIRTUAL MACHINE."
  type        = string

  validation {
    condition     = length(var.admin_username) >= 1
    error_message = "ADMIN USERNAME MUST NOT BE EMPTY."
  }
}

variable "admin_password" {
  description = "ADMINISTRATOR PASSWORD FOR THE WINDOWS VIRTUAL MACHINE."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.admin_password) >= 6
    error_message = "ADMIN PASSWORD MUST BE AT LEAST 6 CHARACTERS."
  }
}

variable "patch_mode" {
  description = "PATCH ORCHESTRATION MODE OF THE WINDOWS VIRTUAL MACHINE."
  type        = string
  default     = "AutomaticByPlatform"

  validation {
    condition = contains([
      "AutomaticByPlatform",
      "AutomaticByOS",
      "Manual"
    ], var.patch_mode)
    error_message = "INVALID PATCH MODE."
  }
}

variable "bypass_platform_safety_checks_on_user_schedule_enabled" {
  description = "WHETHER PLATFORM SAFETY CHECKS ARE BYPASSED WHEN USING A USER-DEFINED PATCH SCHEDULE."
  type        = bool
  default     = true
}

variable "reboot_setting" {
  description = "REBOOT BEHAVIOR DURING PATCH INSTALLATION."
  type        = string
  default     = "IfRequired"

  validation {
    condition = contains([
      "IfRequired",
      "Never",
      "Always"
    ], var.reboot_setting)
    error_message = "INVALID REBOOT SETTING."
  }
}

variable "os_disk_caching" {
  description = "CACHING TYPE OF THE OS DISK."
  type        = string
  default     = "ReadWrite"

  validation {
    condition = contains([
      "None",
      "ReadOnly",
      "ReadWrite"
    ], var.os_disk_caching)
    error_message = "INVALID OS DISK CACHING VALUE."
  }
}

variable "os_disk_storage_account_type" {
  description = "STORAGE ACCOUNT TYPE FOR THE OS DISK."
  type        = string
  default     = "Standard_LRS"
}

variable "image_publisher" {
  description = "IMAGE PUBLISHER."
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable "image_offer" {
  description = "IMAGE OFFER."
  type        = string
  default     = "WindowsServer"
}

variable "image_sku" {
  description = "IMAGE SKU."
  type        = string
  default     = "2022-Datacenter"
}

variable "image_version" {
  description = "IMAGE VERSION."
  type        = string
  default     = "latest"
}

variable "identity_type" {
  description = "TYPE OF MANAGED IDENTITY ASSIGNED TO THE WINDOWS VIRTUAL MACHINE."
  type        = string
  default     = "SystemAssigned"

  validation {
    condition = contains([
      "SystemAssigned",
      "UserAssigned",
      "SystemAssigned, UserAssigned"
    ], var.identity_type)
    error_message = "INVALID IDENTITY TYPE."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE WINDOWS VIRTUAL MACHINE."
  type        = map(string)
  default     = {}
}