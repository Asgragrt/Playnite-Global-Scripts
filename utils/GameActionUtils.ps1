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

function Get-GameAction {
    param(
        [String]$GameName
    )

    $GameAction = $null
    $GameScripts = Get-ChildItem .\gameSpecific\*.ps1
    foreach ($GmScript in $GameScripts) {
        $GameScriptPath = $GmScript.FullName
        try {
            $GameObj = & $($GmScript.FullName) 
        }
        catch {
            throw "$($_.Exception.Message)`nat: $($GameScriptPath)"
        }

        if ($GameName -match $GameObj.Name) {
            $GameAction = $GameObj
        }
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