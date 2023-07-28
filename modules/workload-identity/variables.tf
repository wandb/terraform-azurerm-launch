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
  validation {
    condition     = can(regex("^https://.*", var.oidc_issuer))
    error_message = "The OIDC Issuer URL must start with https:// please check that `workload_identity_enabled = true` and `oidc_issuer_enabled = true` for your AKS cluster. Note: `az aks update -g <RESOURCE_GROUP> -n myAKSCluster --enable-oidc-issuer --enable-workload-identity` can be run to enable these features."
  }
}

variable "kubelet_identity" {
  description = "The kubelet identity to use for the acr pull federation"
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