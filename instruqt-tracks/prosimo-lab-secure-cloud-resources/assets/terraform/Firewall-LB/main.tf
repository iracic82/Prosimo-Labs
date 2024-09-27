# Data block to reference the existing subnet "LoadBalancerSubnet"
data "azurerm_subnet" "loadbalancer_subnet" {
  name                 = "LoadBalancerSubnet"
  virtual_network_name = "Lab-Firewall-vnet"
  resource_group_name  = var.rg
}

# Basic Load Balancer with Frontend IP Configuration
resource "azurerm_lb" "basic_lb" {
  name                = "Lab-Basic-LB"
  location            = var.location
  resource_group_name = var.rg
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "firewall-frontend-ip"
    subnet_id                     = data.azurerm_subnet.loadbalancer_subnet.id  # Corrected reference
    private_ip_address_allocation = "Dynamic"  # Use Dynamic or Static
  }
}
