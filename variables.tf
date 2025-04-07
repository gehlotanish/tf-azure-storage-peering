variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "location" {
  description = "Azure region where the resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "Map of subnets to create (Mandatory)"
  type = map(object({
    address_prefixes  = list(string)
    service_endpoints = optional(list(string), [])
  }))
}

variable "vnet_peerings" {
  description = "Map of VNet peerings with directional settings"
  type = map(object({
    remote_vnet_id              = string
    remote_virtual_network_name = string
    remote_resource_group_name  = string

    local_settings = optional(object({
      allow_virtual_network_access = optional(bool)
      allow_forwarded_traffic      = optional(bool)
      allow_gateway_transit        = optional(bool)
      use_remote_gateways          = optional(bool)
    }), {})

    remote_settings = optional(object({
      allow_virtual_network_access = optional(bool)
      allow_forwarded_traffic      = optional(bool)
      allow_gateway_transit        = optional(bool)
      use_remote_gateways          = optional(bool)
    }), {})
  }))
  default = {}
}
