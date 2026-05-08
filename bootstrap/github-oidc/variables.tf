variable "project_name" {
  description = "PROJECT NAME USED FOR NAMING."
  type        = string
  default     = "network-platform"
}

variable "github_repository" {
  description = "GITHUB REPOSITORY IN THE FORMAT owner/repo."
  type        = string
}

variable "github_branch" {
  description = "GITHUB BRANCH USED FOR OIDC."
  type        = string
  default     = "main"
}