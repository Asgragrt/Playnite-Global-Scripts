function Get-GameAction {
    param(
        [String]$GameName
    )

    $GameActionName = Get-GameScriptName $GameName

    $CurrentLocation = Get-Location
    $GameActionPath = "$CurrentLocation\gameSpecific\$GameActionName.ps1"
    if ([string]::IsNullOrWhiteSpace($GameActionName) -or ![System.IO.File]::Exists($GameActionPath)) {
        return
    }

    # We expect that the script returns an appropriate GameActions instance
    $GameAction = & $GameActionPath
    if ($null -eq $GameAction -or $GameAction.GetType().FullName -ne [GameActions]) {
        throw "Invalid GameAction for $GameName on:`n $GameActionPath"
    }
    $GameAction
}