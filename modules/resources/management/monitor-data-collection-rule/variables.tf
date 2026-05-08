variable "name" {
  description = "NAME OF THE DATA COLLECTION RULE."
  type        = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "location" {
  description = "AZURE REGION WHERE THE DATA COLLECTION RULE WILL BE DEPLOYED."
  type        = string
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE DATA COLLECTION RULE WILL BE DEPLOYED."
  type        = string
}

variable "log_analytics_workspace_resource_id" {
  description = "RESOURCE ID OF THE LOG ANALYTICS WORKSPACE DESTINATION."
  type        = string

  validation {
    condition     = length(var.log_analytics_workspace_resource_id) > 0
    error_message = "THE LOG ANALYTICS WORKSPACE RESOURCE ID MUST NOT BE EMPTY."
  }
}

variable "performance_counter_sampling_frequency_in_seconds" {
  description = "SAMPLING FREQUENCY IN SECONDS FOR PERFORMANCE COUNTER COLLECTION."
  type        = number
  default     = 60

  validation {
    condition     = var.performance_counter_sampling_frequency_in_seconds > 0
    error_message = "THE PERFORMANCE COUNTER SAMPLING FREQUENCY MUST BE GREATER THAN 0."
  }
}

variable "performance_counter_specifiers" {
  description = "LIST OF WINDOWS PERFORMANCE COUNTER SPECIFIERS TO COLLECT."
  type        = list(string)

  validation {
    condition = alltrue([
      for counter in var.performance_counter_specifiers : length(counter) > 0
    ])
    error_message = "ALL PERFORMANCE COUNTER SPECIFIERS MUST BE NON-EMPTY."
  }
}

variable "windows_event_log_x_path_queries" {
  description = "LIST OF XPATH QUERIES FOR WINDOWS EVENT LOG COLLECTION."
  type        = list(string)

  validation {
    condition = alltrue([
      for query in var.windows_event_log_x_path_queries : length(query) > 0
    ])
    error_message = "ALL WINDOWS EVENT LOG XPATH QUERIES MUST BE NON-EMPTY."
  }
}

variable "description" {
  description = "DESCRIPTION OF THE DATA COLLECTION RULE."
  type        = string
  default     = null
}

variable "tags" {
  description = "TAGS TO APPLY TO THE DATA COLLECTION RULE."
  type        = map(string)
  default     = {}
}