function Open-App {
    param(
        [String]$AppPath,
        [String]$AppProcessName,
        [String]$AppArguments,
        [String]$AppWindowStyle
    )

    if ([string]::IsNullOrWhiteSpace($AppPath)) {
        throw "Open-App: Please specify the value of '`$AppPath'!"
    }

    # Check if executable exists
    $executableExists = [System.IO.File]::Exists($AppPath)
    if (!$executableExists) {
        throw "Open-App: Could not find the executable!"
    }

    # Check if process is running
    $isAlreadyRunning = Get-Process_ $AppPath $AppProcessName
    if ($isAlreadyRunning) {
        return
    }

    $appWD = [System.IO.Path]::GetDirectoryName($AppPath)
    $appInfo = New-Object System.Diagnostics.ProcessStartInfo
    $appInfo.FileName = $AppPath
    $appInfo.WorkingDirectory = $appWD
    $appInfo.Arguments = $AppArguments
    if (![string]::IsNullOrWhiteSpace($AppWindowStyle)) {
        $appInfo.WindowStyle = $AppWindowStyle
    }
    [System.Diagnostics.Process]::Start($appInfo)
}