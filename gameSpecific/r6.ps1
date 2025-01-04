[GameActions]::new(
    @{
        Name       = 'rainbow six siege'
        PreAction  = {
            # Reduce discord volume
            Set-AppVolume -AppProcessName 'Discord' -AppVolume 50
        }
        ExitAction = {
            # Reset discord volume
            Set-AppVolume -AppProcessName 'Discord' -AppVolume 100
        }
    })
