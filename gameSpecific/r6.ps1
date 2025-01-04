[GameActions]::new(
    @{
        Name       = 'rainbow six siege'
        PreAction  = {
            Set-AppVolume -AppProcessName 'Discord' -AppVolume 50
        }
        ExitAction = {
            Set-AppVolume -AppProcessName 'Discord' -AppVolume 100
        }
    })
