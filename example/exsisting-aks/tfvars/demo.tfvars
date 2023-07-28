# Infra variables
subscription_id = "636d899d-..."
namespace       = "demo"
location        = "eastus"

# launch-helm variables
helm_chart_version    = "0.8.0"
agent_api_key         = "local-0d2..."
agent_image           = "wandb/launch-agent-dev:f0cf9e0a"
create_resource_group = false
resource_group_name   = "...-sandbox-ns"
aks_cluster_name      = "...-sandbox-ns-cluster"

# agent_image_pull_policy = "Always"

# agent_resources = {
#   limits = {
#     cpu    = "1"
#     memory = "1Gi"
#   }
# }

k8s_namespace = "wandb"
base_url      = "https://....wandb.ml"
# volcano   = false
# git_creds = ""

additional_target_namespaces = ["default", "wandb"]

# launch_config variables
queues = ["azure-demo-queue"]
entity = "azure-demo-team"
# max_jobs       = "5"
# max_schedulers = "8"

tags = {}
