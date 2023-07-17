# Infra variables
subscription_id = "636d899d-58b4-4d7b-9e56-7a984388b4c8"
namespace       = "demo"
location        = "eastus"

# launch-helm variables
helm_chart_version    = "0.8.0"
agent_api_key         = "local-0d241a968fc03b9c687cf911368e4a053f16a4ce"
agent_image           = "wandb/launch-agent-dev:f0cf9e0a"
create_resource_group = false
resource_group_name   = "blasczyk-sandbox-ns"
aks_cluster_name      = "blasczyk-sandbox-ns-cluster"

# agent_image_pull_policy = "Always"

# agent_resources = {
#   limits = {
#     cpu    = "1"
#     memory = "1Gi"
#   }
# }

k8s_namespace = "wandb"
node_count    = 1
base_url      = "https://blasczyk-azure.sandbox-azure.wandb.ml"
# volcano   = false
# git_creds = ""

additional_target_namespaces = ["default", "wandb"]

# launch_config variables
queues = ["azure-demo-queue"]
entity = "azure-demo-team"
# max_jobs       = "5"
# max_schedulers = "8"

tags = {}
