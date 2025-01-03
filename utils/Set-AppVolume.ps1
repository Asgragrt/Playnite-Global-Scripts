# Get exe from here https://www.nirsoft.net/utils/nircmd.html
# and put it on your path variable or change the path from here.

# Change path or command name here
$nircmdCommand = 'nircmd'

function Set-AppVolume {
    param(
        [String]$AppPath,
        [String]$AppProcessName,
        [Parameter(Mandatory)]
        [int]$AppVolume # Percentage 0-100 of system volume
    )

    if (($AppVolume -lt 0) -or ($AppVolume -gt 100)) {
        throw 'Set-AppVolume: $AppVolume should be between 0 and 100'
    }

    # Check if nircmd exists
    $null = Get-Command $nircmdCommand

    $Volume = "$([math]::Round($AppVolume / 100, 2))"

    Get-Process_ $AppPath $AppProcessName | ForEach-Object { 
        Invoke-Expression "$nircmdCommand setappvolume /$($_.Id) $Volume" 
    }
} 