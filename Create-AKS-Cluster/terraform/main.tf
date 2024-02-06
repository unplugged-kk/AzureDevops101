resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = "kishore-aks-cluster"
  location            = var.location
  resource_group_name = var.rg
  dns_prefix          = "kishore-aks-cluster"

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  network_profile {
    network_plugin     = "azure"
    service_cidr       = "10.0.3.0/24" # Non-overlapping CIDR for Kubernetes services
    dns_service_ip     = "10.0.3.10"   # Must be within the service CIDR
    docker_bridge_cidr = "172.17.0.1/16"
  }


  identity {
    type = "SystemAssigned"
  }

  ingress_application_gateway {
    gateway_id = azurerm_application_gateway.kishore_appgw.id
  }

  tags = {
    Environment = "Production"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user_node_pool" {
  name                  = "usernodepool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks_cluster.id
  vm_size               = "Standard_D2_v2"
  node_count            = 2
  // Additional configurations such as taints, labels, or auto-scaling can be added here
}
