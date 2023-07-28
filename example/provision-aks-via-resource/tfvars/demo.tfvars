# Infra variables
subscription_id = "636d899d-..."
namespace       = "demo"
location        = "eastus"

# launch-helm variables
# helm_repository       = https://wandb.github.io/helm-charts
helm_chart_version = "0.8.0"
agent_api_key      = "local-3..."
agent_image        = "wandb/launch-agent-dev:f0cf9e0a"
# We will create the resource group, this variable just tells the root module
# not to try and create the resource group again.
create_resource_group = false
# agent_image_pull_policy = "Always"

# agent_resources = {
#   limits = {
#     cpu    = "1"
#     memory = "1Gi"
#   }
# }

k8s_namespace = "wandb"
node_count    = 1
base_url      = "https://${WANDB_URL}"
# volcano   = false
# git_creds = ""

additional_target_namespaces = ["default", "wandb"]

# launch_config variables
queues = ["azure-demo-queue"]
entity = "azure-demo-team"
# max_jobs       = "5"
# max_schedulers = "8"

tags = {}