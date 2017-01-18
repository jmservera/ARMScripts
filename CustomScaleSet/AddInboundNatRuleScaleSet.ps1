#Login-AzureRmAccount

$rgName = 'jmvmss'
$vmssName = 'jmvmss01'
$lbName = $vmssName + 'ilb' 


$slb = Get-AzureRmLoadBalancer -Name $lbName -ResourceGroupName $rgName
$frontend=Get-AzureRmLoadBalancerFrontendIpConfig -LoadBalancer $slb


$inboundNatPoolConfigName=$vmssName + 'inatpool8080'
$inboundNatPoolName= $inboundNatPoolConfigName + '.0'

$frontendpoolrangestart = 58000
$frontendpoolrangeend = 58199
$backendvmport = 8080
$inboundPoolConfig= Add-AzureRmLoadBalancerInboundNatPoolConfig -Name $inboundNatPoolConfigName -LoadBalancer $slb -Protocol Tcp -FrontendIpConfigurationId $frontend.Id ` -FrontendPortRangeStart $frontendpoolrangestart -FrontendPortRangeEnd $frontendpoolrangeend -BackendPort $backendvmport;

$inboundNatRule= Add-AzureRmLoadBalancerInboundNatRuleConfig -Name $inboundNatPoolName -LoadBalancer $slb -Protocol Tcp -FrontendIpConfigurationId $frontend.Id `-FrontendPort $frontendpoolrangestart -BackendPort $backendvmport;

$slb | Set-AzureRmLoadBalancer




