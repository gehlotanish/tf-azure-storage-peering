# terraform code azure vnet and peering

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 0.12.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.25.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.13.0 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.25.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.13.0 |
## Modules

No modules.
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | List of DNS servers | `list(string)` | `[]` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region where the resources will be created | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnets to create (Mandatory) | <pre>map(object({<br>    address_prefixes  = list(string)<br>    service_endpoints = optional(list(string), [])<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the resources | `map(string)` | `{}` | no |
| <a name="input_vnet_address_space"></a> [vnet\_address\_space](#input\_vnet\_address\_space) | Address space for the virtual network | `list(string)` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the virtual network | `string` | n/a | yes |
| <a name="input_vnet_peerings"></a> [vnet\_peerings](#input\_vnet\_peerings) | Map of VNet peerings to create (Optional) | <pre>map(object({<br>    remote_vnet_id               = string<br>    allow_virtual_network_access = optional(bool, true)<br>    allow_forwarded_traffic      = optional(bool, false)<br>    allow_gateway_transit        = optional(bool, false)<br>    use_remote_gateways          = optional(bool, false)<br>  }))</pre> | `{}` | no |  
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_peering_ids"></a> [peering\_ids](#output\_peering\_ids) | IDs of the created VNet peerings |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | IDs of the created subnets |
| <a name="output_vnet_id"></a> [vnet\_id](#output\_vnet\_id) | ID of the created Virtual Network |
<!-- END_TF_DOCS -->


## Usage

```yaml
vnet_name           = "my-vnet"
location            = "eastus"
resource_group_name = "my-resource-group"
vnet_address_space  = ["10.0.0.0/16"]
dns_servers         = ["8.8.8.8", "8.8.4.4"]

tags = {
  Environment = "Production"
  Owner       = "Team-Infra"
}

subnets = {
  subnet1 = {
    address_prefixes  = ["10.0.1.0/24"]
    service_endpoints = ["Microsoft.Storage"]
  }
  subnet2 = {
    address_prefixes = ["10.0.2.0/24"]
  }
}

# Optionally add peerings. To skip peerings, simply leave it as an empty map.
vnet_peerings = {
  # Example peering:
  # peer1 = {
  #   remote_vnet_id              = "/subscriptions/12345678/resourceGroups/peer-rg/providers/Microsoft.Network/virtualNetworks/remote-vnet"
  #   allow_virtual_network_access = true
  #   allow_forwarded_traffic      = false
  #   allow_gateway_transit        = false
  #   use_remote_gateways          = false
  # }
}

```
