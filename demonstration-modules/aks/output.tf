output "cluster" {
  value = azurerm_kubernetes_cluster.launch_cluster
}

output "cluster_host" {
  value = azurerm_kubernetes_cluster.launch_cluster.kube_config.0.host
}

output "cluster_client_certificate" {
  value = azurerm_kubernetes_cluster.launch_cluster.kube_config.0.client_certificate
}

output "cluster_client_key" {
  value = azurerm_kubernetes_cluster.launch_cluster.kube_config.0.client_key
}

output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.launch_cluster.kube_config.0.cluster_ca_certificate
  sensitive = true
}

output "cluster_oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.launch_cluster.oidc_issuer_url
}

output "kubelet_identity" {
  value = azurerm_kubernetes_cluster.launch_cluster.kubelet_identity[0].object_id
}