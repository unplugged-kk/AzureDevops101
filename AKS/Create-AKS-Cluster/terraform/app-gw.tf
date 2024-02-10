resource "azurerm_application_gateway" "kishore_appgw" {
  name                = "kishore-appgw"
  location            = var.location
  resource_group_name = azurerm_kubernetes_cluster.aks_cluster.node_resource_group

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "appgw-gateway-ip-configuration"
    subnet_id = azurerm_subnet.appgw_subnet.id
  }

  frontend_port {
    name = "appgw-frontend-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip-configuration"
    public_ip_address_id = azurerm_public_ip.appgw_public_ip.id
  }

  # Backend Address Pool
  backend_address_pool {
    name = "appgw-backend-pool"
  }

  # HTTP Health Probe
  probe {
    name                = "appgw-http-probe"
    protocol            = "Http"
    path                = "/"
    host                = "localhost"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
  }

  # HTTPS Health Probe
  probe {
    name                = "appgw-https-probe"
    protocol            = "Https"
    path                = "/"
    host                = "localhost"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
  }

  # HTTP Settings
  backend_http_settings {
    name                  = "appgw-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 30
    probe_name            = "appgw-http-probe" # Associate HTTP probe with backend settings
  }

  # HTTPS Settings
  backend_http_settings {
    name                  = "appgw-https-settings"
    cookie_based_affinity = "Disabled"
    port                  = 443
    protocol              = "Https"
    request_timeout       = 30
    probe_name            = "appgw-https-probe" # Associate HTTPS probe with backend settings
  }

  # HTTP Listener
  http_listener {
    name                           = "appgw-http-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip-configuration"
    frontend_port_name             = "appgw-frontend-port"
    protocol                       = "Http"
  }

  # Routing Rules
  request_routing_rule {
    name                       = "appgw-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "appgw-http-listener"
    backend_address_pool_name  = "appgw-backend-pool"
    backend_http_settings_name = "appgw-http-settings"
    priority                   = 100 # Add a priority value here
  }

  #   # Web Application Firewall (WAF) Configuration
  #   waf_configuration {
  #     enabled          = true
  #     firewall_mode    = "Prevention"
  #     rule_set_type    = "OWASP"
  #     rule_set_version = "3.0"
  #   }
}
