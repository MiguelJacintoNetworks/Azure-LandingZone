variable "name" {
  description = "NAME OF THE SCHEDULED QUERY ALERT."
  type        = string

  validation {
    condition     = length(var.name) >= 1
    error_message = "THE NAME MUST NOT BE EMPTY."
  }
}

variable "resource_group_name" {
  description = "NAME OF THE RESOURCE GROUP WHERE THE SCHEDULED QUERY ALERT WILL BE DEPLOYED."
  type        = string
}

variable "location" {
  description = "AZURE REGION WHERE THE SCHEDULED QUERY ALERT WILL BE DEPLOYED."
  type        = string
}

variable "scopes" {
  description = "LIST OF RESOURCE IDS IN SCOPE FOR THE SCHEDULED QUERY ALERT."
  type        = list(string)

  validation {
    condition     = length(var.scopes) > 0
    error_message = "AT LEAST ONE SCOPE MUST BE PROVIDED."
  }
}

variable "description" {
  description = "DESCRIPTION OF THE SCHEDULED QUERY ALERT."
  type        = string
  default     = null
}

variable "severity" {
  description = "SEVERITY OF THE SCHEDULED QUERY ALERT."
  type        = number
  default     = 2

  validation {
    condition     = var.severity >= 0 && var.severity <= 4
    error_message = "SEVERITY MUST BE BETWEEN 0 AND 4."
  }
}

variable "enabled" {
  description = "WHETHER THE SCHEDULED QUERY ALERT IS ENABLED."
  type        = bool
  default     = true
}

variable "evaluation_frequency" {
  description = "EVALUATION FREQUENCY OF THE SCHEDULED QUERY ALERT."
  type        = string
  default     = "PT5M"

  validation {
    condition     = length(var.evaluation_frequency) > 0
    error_message = "THE EVALUATION FREQUENCY MUST NOT BE EMPTY."
  }
}

variable "window_duration" {
  description = "WINDOW DURATION OF THE SCHEDULED QUERY ALERT."
  type        = string
  default     = "PT10M"

  validation {
    condition     = length(var.window_duration) > 0
    error_message = "THE WINDOW DURATION MUST NOT BE EMPTY."
  }
}

variable "query" {
  description = "KUSTO QUERY USED BY THE SCHEDULED QUERY ALERT."
  type        = string

  validation {
    condition     = length(var.query) > 0
    error_message = "THE QUERY MUST NOT BE EMPTY."
  }
}

variable "time_aggregation_method" {
  description = "TIME AGGREGATION METHOD OF THE SCHEDULED QUERY ALERT."
  type        = string
  default     = "Count"

  validation {
    condition = contains([
      "Average",
      "Count",
      "Maximum",
      "Minimum",
      "Total"
    ], var.time_aggregation_method)
    error_message = "INVALID TIME AGGREGATION METHOD."
  }
}

variable "operator" {
  description = "COMPARISON OPERATOR OF THE SCHEDULED QUERY ALERT THRESHOLD."
  type        = string

  validation {
    condition = contains([
      "Equal",
      "GreaterThan",
      "GreaterThanOrEqual",
      "LessThan",
      "LessThanOrEqual"
    ], var.operator)
    error_message = "INVALID OPERATOR."
  }
}

variable "threshold" {
  description = "THRESHOLD VALUE OF THE SCHEDULED QUERY ALERT."
  type        = number
}

variable "number_of_evaluation_periods" {
  description = "TOTAL NUMBER OF EVALUATION PERIODS."
  type        = number
  default     = 1

  validation {
    condition     = var.number_of_evaluation_periods >= 1
    error_message = "THE NUMBER OF EVALUATION PERIODS MUST BE GREATER THAN OR EQUAL TO 1."
  }
}

variable "minimum_failing_periods_to_trigger_alert" {
  description = "MINIMUM NUMBER OF FAILING PERIODS REQUIRED TO TRIGGER THE ALERT."
  type        = number
  default     = 1

  validation {
    condition     = var.minimum_failing_periods_to_trigger_alert >= 1
    error_message = "THE MINIMUM FAILING PERIODS TO TRIGGER THE ALERT MUST BE GREATER THAN OR EQUAL TO 1."
  }
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
  description = "TAGS TO APPLY TO THE SCHEDULED QUERY ALERT."
  type        = map(string)
  default     = {}
}