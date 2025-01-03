<# 
    Map partial name to file
    Key     - A valid wildcard for the game name
    Value   - A valid script name on the `gameSpecific` directory
#>
$GamesMap = @{
    "osu" = "osu"
}

class GameActions {
    [scriptblock] $PreAction
    [scriptblock] $PostAction
    [scriptblock] $ExitAction
}

function Get-GameScriptName {
    param(
        [String]$GameName
    )

    $GamesMap.GetEnumerator() | Where-Object { $GameName -match $_.Key } | Select-Object -ExpandProperty Value
}

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
        throw "Get-GameAction: Invalid GameAction for $GameName on:`n $GameActionPath"
    }
    $GameAction
}

function Start-GameAction {
    param(
        [String]$GameName,
        [String]$ActionType
    )

    $GameAction = Get-GameAction $GameName

    $StageAction = switch ($ActionType) {
        "pre" { $GameAction.PreAction; break }
        "post" { $GameAction.PostAction; break }
        "exit" { $GameAction.ExitAction; break }
    }

    if ($null -ne $StageAction) {
        Invoke-Command -ScriptBlock $StageAction
    }
}