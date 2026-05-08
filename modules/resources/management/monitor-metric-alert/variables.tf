variable "name" {
  description = "NAME OF THE METRIC ALERT."
  type        = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE METRIC ALERT WILL BE DEPLOYED."
  type        = string
}

variable "scopes" {
  description = "LIST OF RESOURCE IDS MONITORED BY THE METRIC ALERT."
  type        = list(string)

  validation {
    condition     = length(var.scopes) > 0
    error_message = "AT LEAST ONE SCOPE MUST BE PROVIDED."
  }
}

variable "description" {
  description = "DESCRIPTION OF THE METRIC ALERT."
  type        = string
  default     = null
}

variable "severity" {
  description = "SEVERITY OF THE METRIC ALERT."
  type        = number
  default     = 2

  validation {
    condition     = var.severity >= 0 && var.severity <= 4
    error_message = "SEVERITY MUST BE BETWEEN 0 AND 4."
  }
}

variable "enabled" {
  description = "WHETHER THE METRIC ALERT IS ENABLED."
  type        = bool
  default     = true
}

variable "frequency" {
  description = "EVALUATION FREQUENCY OF THE METRIC ALERT."
  type        = string
  default     = "PT1M"

  validation {
    condition     = length(var.frequency) > 0
    error_message = "THE EVALUATION FREQUENCY MUST NOT BE EMPTY."
  }
}

variable "window_size" {
  description = "WINDOW SIZE OF THE METRIC ALERT."
  type        = string
  default     = "PT5M"

  validation {
    condition     = length(var.window_size) > 0
    error_message = "THE WINDOW SIZE MUST NOT BE EMPTY."
  }
}

variable "metric_namespace" {
  description = "METRIC NAMESPACE OF THE TARGET RESOURCE."
  type        = string

  validation {
    condition     = length(var.metric_namespace) > 0
    error_message = "THE METRIC NAMESPACE MUST NOT BE EMPTY."
  }
}

variable "metric_name" {
  description = "NAME OF THE METRIC TO MONITOR."
  type        = string

  validation {
    condition     = length(var.metric_name) > 0
    error_message = "THE METRIC NAME MUST NOT BE EMPTY."
  }
}

variable "aggregation" {
  description = "AGGREGATION TYPE OF THE METRIC ALERT."
  type        = string

  validation {
    condition = contains([
      "Average",
      "Count",
      "Maximum",
      "Minimum",
      "Total"
    ], var.aggregation)
    error_message = "INVALID AGGREGATION TYPE."
  }
}

variable "operator" {
  description = "COMPARISON OPERATOR OF THE METRIC ALERT THRESHOLD."
  type        = string

  validation {
    condition = contains([
      "Equals",
      "GreaterThan",
      "GreaterThanOrEqual",
      "LessThan",
      "LessThanOrEqual",
      "NotEquals"
    ], var.operator)
    error_message = "INVALID OPERATOR."
  }
}

variable "threshold" {
  description = "THRESHOLD VALUE OF THE METRIC ALERT."
  type        = number
}

variable "action_group_id" {
  description = "RESOURCE ID OF THE ACTION GROUP."
  type        = string

  validation {
    condition     = length(var.action_group_id) > 0
    error_message = "THE ACTION GROUP ID MUST NOT BE EMPTY."
  }
}

variable "tags" {
  description = "TAGS TO APPLY TO THE METRIC ALERT."
  type        = map(string)
  default     = {}
}