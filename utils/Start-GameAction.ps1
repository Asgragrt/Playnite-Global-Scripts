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