output "helm_release_status" {
  value       = module.launch_helm.helm_release_status
  description = "Status of the helm release"
}