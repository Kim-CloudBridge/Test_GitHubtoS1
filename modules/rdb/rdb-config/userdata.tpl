<powershell>
    New-Item -Path C:\ -Name log -ItemType Directory
    $transcriptPath = 'C:\log\user-data-transcript.txt'
    Start-Transcript $transcriptPath
    Write-Host "Userdata Start..."

    # Get the availability zone from instance metadata
    $AZ = Invoke-RestMethod -Uri http://169.254.169.254/latest/meta-data/placement/availability-zone
    $REGION_VAR = $AZ -replace '[a-z]$'

    # Determine the HOSTNAME_SUFFIX based on the availability zone
    $HOSTNAME_SUFFIX = switch ($AZ) {
        { $_ -match "a$" } { "01" }
        { $_ -match "b$" } { "02" }
        default { "00" }
    }

    # Rename the machine
    $NEW_NAME = "${hostname}-$HOSTNAME_SUFFIX"
    Rename-Computer -NewName $NEW_NAME -Force

    Restart-Computer -Force
</powershell>