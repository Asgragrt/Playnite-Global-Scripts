function Close-App {
    param (
        [scriptblock]$ProcessFilter,
        [int]$CloseDelay
    )

    if ($CloseDelay -lt 0) {
        throw "Close-Delayed: '`$CloseDelay' should be greater than or equal to 0"
    }

    $process = Get-Process | Where-Object $ProcessFilter
    if (!$process) {
        Exit 0
    }

    # Run as a job to avoid blocking the other scripts
    Start-Job -ScriptBlock {
        param ($ProcessId, $Delay)

        #Wait a little bit before killing the process
        Start-Sleep -s $Delay

        # Check again if the process still exists
        if (!(Get-Process -Id $ProcessId)) {
            Exit 0
        }

        Stop-Process -Id $ProcessId
    } -ArgumentList $process.Id, $CloseDelay
}
