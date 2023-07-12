variable "resource_group_name" {
  description = "Resource group in which to create the resources"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "container_name" {
  description = "The name of the blob container"
  type        = string
}

variable "location" {
  description = "The location of the resources"
  type        = string
}

variable "account_tier" {
  description = "The performance tier of the storage account"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The type of replication to use for the storage account"
  type        = string
  default     = "LRS"
}

variable "tags" {
  description = "Tags to be assigned to the storage account"
  type        = map(string)
  default     = {}
}

variable "container_access_type" {
  description = "The access type of the storage container"
  type        = string
  default     = "private"
}