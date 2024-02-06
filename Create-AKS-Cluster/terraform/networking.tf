resource "azurerm_virtual_network" "kishore_aks_vnet" {
  name                = "kishore-aks-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.rg
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "aks-subnet"
  resource_group_name  = var.rg
  virtual_network_name = azurerm_virtual_network.kishore_aks_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "appgw_subnet" {
  name                 = "appgw-subnet"
  resource_group_name  = var.rg
  virtual_network_name = azurerm_virtual_network.kishore_aks_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}


resource "azurerm_public_ip" "appgw_public_ip" {
  name                = "appgw-public-ip"
  location            = var.location
  resource_group_name = var.rg
  allocation_method   = "Static"
  sku                 = "Standard" # Ensure this is set to Standard for Standard_v2 Application Gateway
}

resource "azurerm_application_gateway" "kishore_appgw" {
  name                = "kishore-appgw"
  location            = var.location
  resource_group_name = var.rg

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
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

  # HTTP Settings
  backend_http_settings {
    name                  = "appgw-http-settings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 20
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
  }

  #   # Web Application Firewall (WAF) Configuration
  #   waf_configuration {
  #     enabled          = true
  #     firewall_mode    = "Prevention"
  #     rule_set_type    = "OWASP"
  #     rule_set_version = "3.0"
  #   }
}
