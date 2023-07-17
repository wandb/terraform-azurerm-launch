output "helm_release_status" {
  value = module.launch.helm_release_status
}

output "oidc_issuer_url" {
  value = local.oidc_issuer_url
}
  