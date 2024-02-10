output "client_certificate" {
  value     = azurerm_kubernetes_cluster.aks_cluster.kube_config.0.client_certificate
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw

  sensitive = true
}

# Outputs the name of the node resource group created by AKS
output "node_resource_group" {
  value = azurerm_kubernetes_cluster.aks_cluster.node_resource_group
}
