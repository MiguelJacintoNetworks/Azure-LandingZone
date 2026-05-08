variable "name" {
  description = "NAME OF THE POLICY ASSIGNMENT."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 64
    error_message = "THE NAME MUST BE BETWEEN 1 AND 64 CHARACTERS."
  }
}

variable "subscription_id" {
  description = "AZURE SUBSCRIPTION IDENTIFIER. ACCEPTS EITHER A RAW SUBSCRIPTION GUID OR A FULL /SUBSCRIPTIONS/<GUID> RESOURCE ID."
  type        = string

  validation {
    condition = (
      can(regex("^[0-9a-fA-F-]{36}$", var.subscription_id)) ||
      can(regex("^/subscriptions/[0-9a-fA-F-]{36}$", var.subscription_id))
    )
    error_message = "THE SUBSCRIPTION ID MUST BE EITHER A VALID GUID OR A FULL /SUBSCRIPTIONS/<GUID> RESOURCE ID."
  }
}

variable "policy_definition_id" {
  description = "RESOURCE ID OF THE POLICY DEFINITION OR POLICY SET DEFINITION TO ASSIGN."
  type        = string

  validation {
    condition     = length(var.policy_definition_id) > 0
    error_message = "THE POLICY DEFINITION ID MUST NOT BE EMPTY."
  }
}

variable "display_name" {
  description = "DISPLAY NAME OF THE POLICY ASSIGNMENT."
  type        = string

  validation {
    condition     = length(var.display_name) >= 1
    error_message = "THE DISPLAY NAME MUST NOT BE EMPTY."
  }
}

variable "description" {
  description = "DESCRIPTION OF THE POLICY ASSIGNMENT."
  type        = string

  validation {
    condition     = length(var.description) >= 1
    error_message = "THE DESCRIPTION MUST NOT BE EMPTY."
  }
}

variable "metadata" {
  description = "METADATA JSON FOR THE POLICY ASSIGNMENT."
  type        = string
  default     = null

  validation {
    condition     = var.metadata == null || can(jsondecode(var.metadata))
    error_message = "THE METADATA VALUE MUST BE NULL OR A VALID JSON STRING."
  }
}

variable "parameters" {
  description = "PARAMETERS JSON FOR THE POLICY ASSIGNMENT."
  type        = string
  default     = null

  validation {
    condition     = var.parameters == null || can(jsondecode(var.parameters))
    error_message = "THE PARAMETERS VALUE MUST BE NULL OR A VALID JSON STRING."
  }
}