variable "identity_name" {
  description = "Identity name for launch workloads"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group in which to create the resources"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "storage_account_id" {
  description = "The Storage Account ID"
  type        = string
}

variable "acr_id" {
  description = "The ACR ID"
  type        = string
}

variable "oidc_issuer" {
  description = "The OIDC Issuer URL"
  type        = string
}

variable "subject" {
  description = "The OIDC subject"
  type        = string
  default     = "system:serviceaccount:wandb:wandb-launch-serviceaccount"
}

variable "audiences" {
  description = "The OIDC audiences"
  type        = list(string)
  default     = ["api://AzureADTokenExchange"]
}