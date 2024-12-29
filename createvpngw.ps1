param ($rgname='TestRG0', $vnetname='VNet0', $loc='East US', $deleterg=$false)
$gwname = $vnetname + 'GW'
$gwpipname = $vnetname + 'GWPIP'
$gwsubnetname = 'GatewaySubnet'

write-host "Creating RG $rgname and Vnet $vnetname in $loc"
write-host "Creating Gateway $gwname and Public IP $gwpipname"
write-host "Creating Gateway Subnet $gwsubnetname"
write-host "Deleting RG at end: $deleterg"

## URL https://learn.microsoft.com/en-us/azure/vpn-gateway/create-gateway-basic-sku-powershell

# Create a resource group
New-AzResourceGroup -Name $rgname -Location $loc

# Create a virtual network
$vnet = New-AzVirtualNetwork -ResourceGroupName $rgname -Location $loc -Name $vnetname -AddressPrefix 10.1.0.0/16

# Create a subnet configuration
Add-AzVirtualNetworkSubnetConfig -Name Frontend -AddressPrefix 10.1.0.0/24 -VirtualNetwork $vnet

# Set the subnet configuration for the virtual network
$vnet | Set-AzVirtualNetwork

## Add a gateway subnet
# Set a variable for your virtual network.
# $vnet = Get-AzVirtualNetwork -ResourceGroupName $rgname  -Name $vnetname

# Create the gateway subnet
Add-AzVirtualNetworkSubnetConfig -Name $gwsubnetname  -AddressPrefix 10.1.255.0/27 -VirtualNetwork $vnet

# Set the subnet configuration for the virtual network
$vnet | Set-AzVirtualNetwork

## Request a public IP address
$gwpip = New-AzPublicIpAddress -Name $gwpipname -ResourceGroupName $rgname -Location $loc -AllocationMethod Dynamic -Sku Basic

# Create the gateway IP address configuration
$vnet = Get-AzVirtualNetwork -Name $vnetname -ResourceGroupName $rgname
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $gwsubnetname -VirtualNetwork $vnet
$gwipconfig = New-AzVirtualNetworkGatewayIpConfig -Name gwipconfig -SubnetId $subnet.Id -PublicIpAddressId $gwpip.Id


# Create the VPN gateway
New-AzVirtualNetworkGateway -Name $gwname  -ResourceGroupName $rgname -Location $loc -IpConfigurations $gwipconfig -GatewayType "Vpn" -VpnType "RouteBased" -GatewaySku Basic

# View the VPN gateway
Get-AzVirtualNetworkGateway -Name $gwname  -ResourceGroup $rgname


# View the public IP addresses
Get-AzPublicIpAddress -Name $gwpipname  -ResourceGroupName $rgname

# Clean up resources
if ($deleterg) {
    write-host "Deleting RG $rgname"
    Remove-AzResourceGroup -Name $rgname
}
