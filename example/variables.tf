# Infra variables

variable "subscription_id" {
  description = "The Azure subscription ID is a unique identifier that represents your subscription to Microsoft Azure."
  type        = string
}

variable "namespace" {
  description = "The namespace is a user-defined name that provides a unique identifier for organizing and grouping your resources within Azure."
  type        = string
}

variable "location" {
  description = "The location refers to the physical region or datacenter where your Azure resources are deployed."
  type        = string
}

variable "create_resource_group" {
  description = "The 'create_resource_group' variable is a boolean flag that determines whether to create a resource group (RG) in Azure."
  type        = bool
  default     = true
}

variable "create_aks_cluster" {
  description = "Flag to create a aks cluster"
  type        = bool
  default     = true
}

# launch-helm variables
variable "helm_repository" {
  description = "Helm repository URL"
  type        = string
  default     = "https://wandb.github.io/helm-charts"
}

variable "helm_chart_version" {
  description = "Helm chart version"
  type        = string
}

variable "agent_api_key" {
  description = "The Weights and Biases team service account API key"
  type        = string
}

variable "agent_image" {
  description = "Container image to use for the agent"
  type        = string
}

variable "agent_image_pull_policy" {
  description = "Image pull policy for agent image"
  type        = string
  default     = "Always"
}

variable "agent_resources" {
  description = "Resources block for the agent spec"
  type = object({
    limits = map(string)
  })
  default = {
    limits = {
      cpu    = "1"
      memory = "1Gi"
    }
  }
}

variable "k8s_namespace" {
  description = "Namespace to deploy launch agent into"
  type        = string
  default     = "wandb"
}

variable "node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
  default     = 3
}

variable "base_url" {
  description = "W&B api url"
  type        = string
}

variable "volcano" {
  description = "Set to false to disable volcano install"
  type        = bool
  default     = false
}

variable "git_creds" {
  description = "The contents of a git credentials file"
  type        = string
  default     = ""
}

variable "additional_target_namespaces" {
  description = "Additional target namespaces that the launch agent can deploy into"
  type        = list(string)
  default     = ["wandb", "default"]
}

# launch_config varibles

variable "queues" {
  description = "The list of queues to be used"
  type        = list(string)
  # default     = ["azure-demo-queue"]
}

variable "entity" {
  description = "The team entity to be used"
  type        = string
  # default     = "azure-team"
}

variable "max_jobs" {
  description = "The maximum number of jobs"
  type        = string
  default     = "5"
}

variable "max_schedulers" {
  description = "The maximum number of schedulers"
  type        = string
  default     = "8"
}

variable "tags" {
  description = "Tags to be assigned to the project resources."
  type        = map(string)
  default     = {}
}