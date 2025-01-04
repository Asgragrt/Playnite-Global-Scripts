class GameActions {
    GameAction([string]$Name, [scriptblock] $PreAction, [scriptblock] $PostAction, [scriptblock] $ExitAction) {
        $this.Init(@{
                Name       = $Name;
                PreAction  = $PreAction;
                PostAction = $PostAction;
                ExitAction = $ExitAction;
            })
    }
    GameActions([hashtable]$Properties) { $this.Init($Properties) }
    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {
            $this.$Property = $Properties.$Property
        }
        if ([string]::IsNullOrWhiteSpace($this.Name)) {
            throw "GameAction: Game missing name."
        }
    }
    [String] $Name
    [scriptblock] $PreAction
    [scriptblock] $PostAction
    [scriptblock] $ExitAction
}

function Get-GameScriptName {
    param(
        [String]$GameName
    )

    # $GamesMap.GetEnumerator() | Where-Object { $GameName -match $_.Key } | Select-Object -ExpandProperty Value
    Get-ChildItem .\gameSpecific\*.ps1 | ForEach-Object {
        $GameScriptPath = $_.FullName
        try {
            $GameObj = & $($_.FullName) 
        }
        catch {
            throw "$($_.Exception.Message)`nat: $($GameScriptPath)"
        }

        if ($GameName -match $GameObj.Name) {
            $GameObj
        }
    }
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