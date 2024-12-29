param ($rgname='TestRG0', $vnetname='VNet0', $loc='East US')

write-host "Creating RG $rgname and Vnet $vnetname in $loc"

## URL https://learn.microsoft.com/en-us/azure/vpn-gateway/create-gateway-basic-sku-powershell

# Create a resource group
New-AzResourceGroup -Name $rgname -Location $loc

# Create a virtual network
$vnet = New-AzVirtualNetwork -ResourceGroupName $rgname -Location $loc -Name $vnetname -AddressPrefix 10.1.0.0/16

# Create a subnet configuration
Add-AzVirtualNetworkSubnetConfig -Name Frontend -AddressPrefix 10.1.0.0/24 -VirtualNetwork $vnet

# Set the subnet configuration for the virtual network
$vnet | Set-AzVirtualNetwork
