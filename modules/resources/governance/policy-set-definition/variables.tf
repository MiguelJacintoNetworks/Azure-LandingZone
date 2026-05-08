variable "name" {
  description = "NAME OF THE POLICY SET DEFINITION."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 64
    error_message = "THE NAME MUST BE BETWEEN 1 AND 64 CHARACTERS."
  }
}

variable "display_name" {
  description = "DISPLAY NAME OF THE POLICY SET DEFINITION."
  type        = string

  validation {
    condition     = length(var.display_name) >= 1
    error_message = "THE DISPLAY NAME MUST NOT BE EMPTY."
  }
}

variable "description" {
  description = "DESCRIPTION OF THE POLICY SET DEFINITION."
  type        = string

  validation {
    condition     = length(var.description) >= 1
    error_message = "THE DESCRIPTION MUST NOT BE EMPTY."
  }
}

variable "policy_type" {
  description = "TYPE OF THE POLICY SET DEFINITION."
  type        = string
  default     = "Custom"

  validation {
    condition = contains([
      "BuiltIn",
      "Custom",
      "NotSpecified",
      "Static"
    ], var.policy_type)
    error_message = "INVALID POLICY TYPE."
  }
}

variable "metadata" {
  description = "METADATA JSON FOR THE POLICY SET DEFINITION."
  type        = string
  default     = null

  validation {
    condition     = var.metadata == null || can(jsondecode(var.metadata))
    error_message = "THE METADATA VALUE MUST BE NULL OR A VALID JSON STRING."
  }
}

variable "policy_definitions" {
  description = "MAP OF POLICY DEFINITIONS INCLUDED IN THE POLICY SET DEFINITION."

  type = map(object({
    policy_definition_id = string
    reference_id         = string
    parameter_values     = optional(string)
  }))

  default = {}

  validation {
    condition = alltrue([
      for policy_definition in values(var.policy_definitions) :
      length(policy_definition.policy_definition_id) > 0 && length(policy_definition.reference_id) > 0
    ])
    error_message = "EACH POLICY DEFINITION ENTRY MUST INCLUDE A NON-EMPTY POLICY DEFINITION ID AND REFERENCE ID."
  }

  validation {
    condition = alltrue([
      for policy_definition in values(var.policy_definitions) :
      try(policy_definition.parameter_values == null || can(jsondecode(policy_definition.parameter_values)), true)
    ])
    error_message = "EACH PARAMETER VALUES ENTRY MUST BE NULL OR A VALID JSON STRING."
  }
}