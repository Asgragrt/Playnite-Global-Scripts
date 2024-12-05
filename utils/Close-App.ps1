function Close-App {
    param (
        [string]$ProcessName,
        [string]$ProcessPath,
        [int]$CloseDelay = 0,
        [int]$MaxProcessCount = 5
    )

    if ([string]::IsNullOrWhiteSpace($ProcessName)) {
        throw "Close-App: Please specify the value of '`$ProcessName'!"
    }

    if ($CloseDelay -lt 0) {
        throw "Close-App: '`$CloseDelay' should be greater than or equal to 0"
    }

    if ($MaxProcessCount -lt 1) {
        throw "Close-App: '`$MaxProcessCount' should be greater than or equal to 1"
    }

    if (![string]::IsNullOrWhiteSpace($ProcessPath)) {
        # $_.ProcessName -match $AppProcessName -or
        $processFilter = { $_.ProcessName -match $ProcessName -or $pinvoke::GetProcessPath($_.Id) -match $ProcessPath }
    }
    else {
        $processFilter = { $_.ProcessName -match $ProcessName }
    }

    $process = Get-Process | Where-Object $processFilter
    if (!$process) {
        Exit 0
    }

    $processCount = $process  | Measure-Object | Select-Object -ExpandProperty Count
    if ($processCount -gt $MaxProcessCount) {
        throw "Close-App: More than $MaxProcessCount process will be stopped, canceling script!`nPlease review the filter."
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
