<# 
    Map partial name to file
    Key     - A valid wildcard for the game name
    Value   - A valid script name on the `gameSpecific` directory
#>
$GamesMap = @{
    "osu" = "osu"
}

function Get-GameScriptName {
    param(
        [String]$GameName
    )

    $GamesMap.GetEnumerator() | Where-Object { $GameName -match $_.Key } | Select-Object -ExpandProperty Value
}