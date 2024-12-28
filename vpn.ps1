## URL https://learn.microsoft.com/en-us/azure/vpn-gateway/create-gateway-basic-sku-powershell

# Create a resource group
New-AzResourceGroup -Name TestRG1 -Location EastUS

# Create a virtual network
$virtualnetwork = New-AzVirtualNetwork -ResourceGroupName TestRG1 -Location EastUS -Name VNet1 -AddressPrefix 10.1.0.0/16

# Create a subnet configuration 
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
  -Name Frontend `
  -AddressPrefix 10.1.0.0/24 `
  -VirtualNetwork $virtualnetwork
  
# Set the subnet configuration for the virtual network
$virtualnetwork | Set-AzVirtualNetwork

## Add a gateway subnet
# Set a variable for your virtual network.
$vnet = Get-AzVirtualNetwork -ResourceGroupName TestRG1 -Name VNet1

# Create the gateway subnet 
Add-AzVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -AddressPrefix 10.1.255.0/27 -VirtualNetwork $vnet

# Set the subnet configuration for the virtual network 
$vnet | Set-AzVirtualNetwork

## Request a public IP address
$gwpip = New-AzPublicIpAddress -Name "VNet1GWIP" -ResourceGroupName "TestRG1" -Location "EastUS" -AllocationMethod Dynamic -Sku Basic

# Create the gateway IP address configuration
$vnet = Get-AzVirtualNetwork -Name VNet1 -ResourceGroupName TestRG1
$subnet = Get-AzVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $vnet
$gwipconfig = New-AzVirtualNetworkGatewayIpConfig -Name gwipconfig -SubnetId $subnet.Id -PublicIpAddressId $gwpip.Id


# Create the VPN gateway
New-AzVirtualNetworkGateway -Name VNet1GW -ResourceGroupName TestRG1 -Location "East US" -IpConfigurations $gwipconfig -GatewayType "Vpn" -VpnType "RouteBased" -GatewaySku Basic

# View the VPN gateway
Get-AzVirtualNetworkGateway -Name Vnet1GW -ResourceGroup TestRG1


# View the public IP addresses
Get-AzPublicIpAddress -Name VNet1GWIP -ResourceGroupName TestRG1

# Clean up resources
Remove-AzResourceGroup -Name TestRG1