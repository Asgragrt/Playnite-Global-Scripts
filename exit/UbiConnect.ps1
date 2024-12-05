# Check if game is from ubisoft
if ($Game.Developers.Name -notmatch "ubisoft") {
    Exit 0
}

Close-App 'upc' 'ubisoft game launcher' 10 10