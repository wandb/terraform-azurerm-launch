# Infra variables
subscription_id = "636d899d..."
namespace       = "demo"
location        = "eastus"

#TODO Support Bringing your own Resource Group or cluster.
# create_resource_group = true
# create_aks_cluster    = true

# launch-helm variables
# helm_repository       = https://wandb.github.io/helm-charts
helm_chart_version = "0.8.0"
agent_api_key      = "local-46fa..."
agent_image        = "wandb/launch-agent-dev:f0cf9e0a"
# agent_image_pull_policy = "Always"

# agent_resources = {
#   limits = {
#     cpu    = "1"
#     memory = "1Gi"
#   }
# }

k8s_namespace = "wandb"
node_count    = 1
base_url      = "https://${URL}.wandb.ml"
# volcano   = false
# git_creds = ""

additional_target_namespaces = ["default", "wandb"]

# launch_config variables
queues = ["azure-demo-queue"]
entity = "azure-team"
# max_jobs       = "5"
# max_schedulers = "8"

tags = {}
