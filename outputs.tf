output "vnet_id" {
  description = "ID of the created Virtual Network"
  value       = azurerm_virtual_network.vnet.id
}

output "subnet_ids" {
  description = "IDs of the created subnets"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "peering_ids" {
  description = "IDs of the created VNet peerings"
  value       = { for k, v in azurerm_virtual_network_peering.peerings : k => v.id }
}

