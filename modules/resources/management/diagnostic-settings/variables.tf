variable "name" {
  description = "NAME OF THE DIAGNOSTIC SETTING."
  type        = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "target_resource_id" {
  description = "RESOURCE ID OF THE TARGET RESOURCE RECEIVING THE DIAGNOSTIC SETTING."
  type        = string

  validation {
    condition     = length(var.target_resource_id) > 0
    error_message = "THE TARGET RESOURCE ID MUST NOT BE EMPTY."
  }
}

variable "log_analytics_workspace_id" {
  description = "RESOURCE ID OF THE LOG ANALYTICS WORKSPACE."
  type        = string

  validation {
    condition     = length(var.log_analytics_workspace_id) > 0
    error_message = "THE LOG ANALYTICS WORKSPACE ID MUST NOT BE EMPTY."
  }
}

variable "enabled_logs" {
  description = "LIST OF LOG CATEGORIES ENABLED FOR THE DIAGNOSTIC SETTING."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for category in var.enabled_logs : length(category) > 0
    ])
    error_message = "ALL ENABLED LOG CATEGORIES MUST BE NON-EMPTY."
  }
}

variable "enabled_metrics" {
  description = "LIST OF METRIC CATEGORIES ENABLED FOR THE DIAGNOSTIC SETTING."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for category in var.enabled_metrics : length(category) > 0
    ])
    error_message = "ALL ENABLED METRIC CATEGORIES MUST BE NON-EMPTY."
  }
}