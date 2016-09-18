$props = @{
  "virtualApplications" = @(
    @{
      "virtualPath" = "/";
      "physicalPath"= "site\wwwroot";
    },
    @{
      "virtualPath" = "/foo";
      "physicalPath"= "site\bar";
    },
        @{
      "virtualPath" = "/what";
      "physicalPath"= "site\wwwroot\whatever";
    },
        @{
      "virtualPath" = "/bar";
      "physicalPath"= "site\wwwroot\bar";
    }
  )
}

$apiVersion="2015-08-01"

$resourceGroupName= "migrationlabs3"
$siteName="jmserverademo003"
$servicePlan="test3"
$location="northeurope"

Remove-Variable siteNotExists
Remove-Variable rgNotExists
Remove-Variable spNotExists


# Login-AzureRmAccount

#Select-AzureRmSubscription -SubscriptionId  xxx


Get-AzureRmResourceGroup -Name $resourceGroupName -ErrorVariable rgNotExists -ErrorAction Continue
if($rgNotExists)
{
    New-AzureRmResourceGroup -Name $resourceGroupName -Location $location
}

Get-AzureRmResource -ResourceGroupName $resourceGroupName -ResourceType Microsoft.Web/serverfarms -ResourceName $servicePlan -ApiVersion $apiVersion -ErrorVariable spNotExists -ErrorAction Continue

if($spNotExists)
{
    New-AzureRmAppServicePlan -Name $servicePlan -Location $location -ResourceGroupName $resourceGroupName `
    -Tier Standard -WorkerSize Small -NumberofWorkers 1
}

Get-AzureRmResource -ResourceGroupName $resourceGroupName -ResourceType Microsoft.Web/sites -ResourceName $siteName -ApiVersion $apiVersion -ErrorVariable siteNotExists -ErrorAction Continue

if($siteNotExists)
{
    New-AzureRmWebApp -ResourceGroupName $resourceGroupName -Name $siteName -AppServicePlan $servicePlan -Location $location
}


Set-AzureRmResource -ResourceGroupName $resourceGroupName `
 -ResourceType Microsoft.Web/sites/config `
  -ResourceName "$siteName/web" `
   -PropertyObject $props `
   -ApiVersion 2015-08-01 -Force
