variable "registry_name" {
  description = "The name of the container registry."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the container registry should be created."
  type        = string
}

variable "location" {
  description = "The location/region where the container registry should be created."
  type        = string
}

variable "sku" {
  description = "The SKU of the container registry."
  type        = string
  default     = "Basic"
}

variable "admin_enabled" {
  description = "Whether or not admin is enabled on the container registry."
  type        = bool
  default     = false
}

variable "network_rule_set" {
  description = "The network rule set for the container registry."
  type        = list(any)
  default     = []
}

variable "quarantine_policy_enabled" {
  description = "Whether or not the quarantine policy is enabled on the container registry."
  type        = bool
  default     = false
}

variable "trust_policy_enabled" {
  description = "Whether or not the trust policy is enabled on the container registry."
  type        = bool
  default     = false
}

variable "retention_policy_days" {
  description = "The number of days for the retention policy on the container registry."
  type        = number
  default     = 7
}

variable "retention_policy_enabled" {
  description = "Whether or not the retention policy is enabled on the container registry."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to be assigned to the container registry."
  type        = map(string)
  default     = {}
}