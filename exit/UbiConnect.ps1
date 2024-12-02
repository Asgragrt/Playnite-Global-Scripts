# Check if game is from ubisoft
if ($Game.Developers.Name -notmatch "ubisoft") {
    Exit 0
}

Close-Delayed { $_.ProcessName -match 'upc' -and $_.Path -match 'ubisoft' } 10