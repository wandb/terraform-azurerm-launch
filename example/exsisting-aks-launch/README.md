# Private Launch Demonstration Only

This directory provides an example of setting up a launch agent into an exsisting AKS cluster. 

**Note** The target AKS cluster should have
```hcl
  workload_identity_enabled = true
  oidc_issuer_enabled       = true
```
enabled in order to configure the [Azure Workload Identity]`https://learn.microsoft.com/en-us/azure/aks/workload-identity-deploy-cluster` needed to pull and bush build contexts to and from the Azure Container Registry and Blob Storage Containers.

If this needs to be confugured manually, please run:
```bash
az aks update -g ${resource_group} -n ${aks_cluster} --enable-oidc-issuer --enable-workload-identity 
```

## Configuration

To start the setup, you need to create a `terraform.tfvars` file inside the `./tfvars` directory. This file will contain all the required configurations for your setup.

Here is a sample of what your `terraform.tfvars` might look like:

```hcl
# Infra variables
subscription_id = "636d899d-..."
namespace       = "demo"
location        = "eastus"

# launch-helm variables
helm_chart_version    = "0.8.0"
agent_api_key         = "local-3..."
agent_image           = "wandb/launch-agent-dev:f0cf9e0a"
create_resource_group = false
resource_group_name   = "blasczyk-sandbox-ns"
aks_cluster_name      = "blasczyk-sandbox-ns-cluster"

k8s_namespace = "wandb"
node_count    = 1
base_url      = "https://${WANDB_URL}"

additional_target_namespaces = ["default", "wandb"]

# launch_config variables
queues = ["azure-demo-queue"]
entity = "azure-demo-team"

tags = {}
```

Please replace the placeholder values with your actual values.

## Variables Explanation

Below is a quick rundown of what each of these variables signifies:

- **Infra variables:** These variables relate to your Azure infrastructure.
    - `subscription_id`: Your Azure subscription ID.
    - `namespace`: A unique name to identify your resources.
    - `location`: The Azure region in which to create resources.

- **launch-helm variables:** These variables are for the Helm chart.
    - `helm_chart_version`: The version of the Helm chart to use.
    - `agent_api_key`: Your Weights and Biases agent API key. This should be a Service Account under the team you created your queue.
    - `agent_image`: The Docker image to use for the agent.
    - `create_resource_group`: Whether or not to create a new resource group or use an exsisting one.
    - `k8s_namespace`: The Kubernetes namespace in which to create resources.
    - `node_count`: The number of nodes to create in the Kubernetes cluster.
    - `base_url`: The base URL for your Weights and Biases setup.
    - `additional_target_namespaces`: Additional Kubernetes namespaces to target Launch Jobs to run in. 

- **launch_config variables:** These variables relate to the launch configuration.
    - `queues`: The queues to use.
    - `entity`: The (team) entity under which to run jobs.
    - `tags`: Any tags to apply to your resources.

## Launching

Once you have set your configurations, you can initialize and apply your Terraform setup with the following commands:

```bash
terraform init -upgrade
terraform apply -var-file=./tfvars/terraform.tfvars
```

You will be asked to confirm your settings before the setup proceeds.

## Cleanup

To clean up the resources created by Terraform, use the following command:

```bash
terraform destroy -var-file=./tfvars/terraform.tfvars
```