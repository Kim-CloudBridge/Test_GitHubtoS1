 <powershell>
    $marker_file = "C:\\log\\userdata_marker.txt"
    if (Test-Path $marker_file) {
      Write-Output "Marker file found. Exiting user data script."
      exit
    }
    $hostname = "${hostname}"
    $sysInfo = Get-WmiObject -Class Win32_ComputerSystem
    $sysInfo.Rename($hostname)

    Install-WindowsFeature -Name AD-Domain-Services, DNS -IncludeManagementTools
    
    New-Item -Path $marker_file -ItemType File
    Restart-Computer -Force
</powershell>