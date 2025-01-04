[GameActions]::new(
    @{
        Name       = 'osu'
        PreAction  = {
            $OpenTableDriverPath = "C:\Users\user\OpenTabletDriver\OpenTabletDriver.UX.Wpf.exe"

            Open-App $OpenTableDriverPath "OpenTabletDriver.Daemon" -AppWindowStyle "Minimized"
        }
        ExitAction = {
            Close-App 'OpenTabletDriver'
        }
    })