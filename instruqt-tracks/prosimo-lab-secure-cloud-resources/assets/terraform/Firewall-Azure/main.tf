#### Code written by Sharol Pereira sharol@prosimo.io for Firewall creation


## resource group creation
resource "azurerm_resource_group" "firewall" {
  name     = "Lab-Firewall-RG"
  location = "North Europe"
}


## Create Vnet and subnet 
resource "azurerm_virtual_network" "firewall" {
  name                = "Lab-Firewall-vnet"
  address_space       = ["10.160.0.0/20"]
  location            = azurerm_resource_group.firewall.location
  resource_group_name = azurerm_resource_group.firewall.name
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.firewall.name
  virtual_network_name = azurerm_virtual_network.firewall.name
  address_prefixes     = ["10.160.1.0/24"]
}

## Subnet for LB
resource "azurerm_subnet" "lb_subnet" {
  name                 = "LoadBalancerSubnet"
  resource_group_name  = azurerm_resource_group.firewall.name
  virtual_network_name = azurerm_virtual_network.firewall.name
  address_prefixes     = ["10.160.0.0/24"]
}

## Public IP 
resource "azurerm_public_ip" "firewall" {
  name                = "Lab-firewall-pip"
  resource_group_name = azurerm_resource_group.firewall.name
  location            = azurerm_resource_group.firewall.location
  allocation_method   = "Static"
  sku                 = "Standard"
}


## Firewall policy 
resource "azurerm_firewall_policy" "firewall_policy" {
  name                = "firewall-policy"
  resource_group_name = azurerm_resource_group.firewall.name
  location            = azurerm_resource_group.firewall.location
  sku                 = "Standard"
  threat_intelligence_mode =  "Alert"
}

resource "azurerm_firewall_policy_rule_collection_group" "firewall" {
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  name               = "allow-traffic-group"
  priority           = 100

  network_rule_collection {
    name     = "Allow-Traffic"
    priority = 100
    action   = "Allow"

    rule {
      name      = "allow-all-traffic"
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
      protocols             = ["Any"]
    }
  }
}


## Firewall
resource "azurerm_firewall" "firewall" {
  name                = "lab-firewall"
  location            = azurerm_resource_group.firewall.location
  resource_group_name = azurerm_resource_group.firewall.name
  sku_name            = "AZFW_VNet"
  sku_tier            =  "Standard" 

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy.id
}

resource "azurerm_route_table" "firewall_route_table" {
  name                = "Firewall-Route-Table"
  resource_group_name = azurerm_resource_group.firewall.name
  location            = azurerm_resource_group.firewall.location
}
