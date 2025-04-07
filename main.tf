resource "time_static" "current" {}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  dns_servers         = var.dns_servers

  tags = merge(
    {
      CreateDate = "${time_static.current.year}/${time_static.current.month}/${time_static.current.day}"
    },
    var.tags
  )
}

resource "azurerm_subnet" "subnets" {
  for_each             = var.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = each.value.address_prefixes
  service_endpoints    = lookup(each.value, "service_endpoints", [])
}

resource "azurerm_virtual_network_peering" "local_to_remote" {
  for_each = var.vnet_peerings

  name                      = "${each.key}-${each.value.remote_virtual_network_name}"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = each.value.remote_vnet_id

  allow_virtual_network_access = lookup(each.value.local_settings, "allow_virtual_network_access", true)
  allow_forwarded_traffic      = lookup(each.value.local_settings, "allow_forwarded_traffic", false)
  allow_gateway_transit        = lookup(each.value.local_settings, "allow_gateway_transit", false)
  use_remote_gateways          = lookup(each.value.local_settings, "use_remote_gateways", false)
}

resource "azurerm_virtual_network_peering" "remote_to_local" {
  for_each = var.vnet_peerings

  name                      = "${each.key}-${azurerm_virtual_network.vnet.name}"
  resource_group_name       = each.value.remote_resource_group_name
  virtual_network_name      = each.value.remote_virtual_network_name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id

  allow_virtual_network_access = lookup(each.value.remote_settings, "allow_virtual_network_access", true)
  allow_forwarded_traffic      = lookup(each.value.remote_settings, "allow_forwarded_traffic", false)
  allow_gateway_transit        = lookup(each.value.remote_settings, "allow_gateway_transit", false)
  use_remote_gateways          = lookup(each.value.remote_settings, "use_remote_gateways", false)
}

