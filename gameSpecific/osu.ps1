$osu = [GameActions]::new()
$osu.PreAction = {
    $OpenTableDriverPath = "C:\Users\user\OpenTabletDriver\OpenTabletDriver.UX.Wpf.exe"

    Open-App $OpenTableDriverPath "OpenTabletDriver.Daemon" -AppWindowStyle "Minimized"
}
$osu.ExitAction = {
    Close-App 'OpenTabletDriver'
}
$osu