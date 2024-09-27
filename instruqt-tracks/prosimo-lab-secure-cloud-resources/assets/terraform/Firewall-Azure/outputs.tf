output "resource_group_name" {
  value = azurerm_resource_group.firewall.name
}

output "firewall_name" {
  value = azurerm_firewall.firewall.name
}