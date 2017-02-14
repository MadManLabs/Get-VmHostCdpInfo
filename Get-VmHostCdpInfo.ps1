<# 
Get-VmHostCdpInfo.ps1

.Description
    Get host vmnic and port id
	
.Acknowledgments 
    
.Example
    ./Get-VmHostCdpInfo.ps1 <ESXi Host>
#>

param($VMHost)

if ($VMHost -ne " "){  
$vmh = Get-VMHost $VMHost

If ($vmh.ConnectionState -ne "Connected") {
  Write-Output "Host is not connected, or specified>" 
  }
Else {
  Get-View $vmh.ID | `
  % { $esxname = $_.Name; Get-View $_.ConfigManager.NetworkSystem} | `
  % { foreach ($physnic in $_.NetworkInfo.Pnic) {
    $pnicInfo = $_.QueryNetworkHint($physnic.Device)
    foreach( $hint in $pnicInfo ){
      # Write-Host $esxname $physnic.Device
      if ( $hint.ConnectedSwitchPort ) {
        $hint.ConnectedSwitchPort | select @{n="VMHost";e={$esxname}},@{n="VMNic";e={$physnic.Device}},DevId,Address,PortId,HardwarePlatform
        }
      else {
        Write-Host "No CDP information available."
        }
      }
    }
  }
}
}
