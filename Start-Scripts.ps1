$ValidDirs = @("pre", "post", "exit")

function Start-Scripts {
    param([string]$Directory)

    if ([string]::IsNullOrWhiteSpace($Directory)) {
        throw "Start-Scripts: Please specify the value of '`$ScriptDir'!"
    }

    $ScriptDir = $Directory.toLower()
    if ($ValidDirs -notcontains $ScriptDir) {
        throw "Start-Scripts: '$ScriptDir' is not a valid script directory!"
    }

    #Use script directory as a reference position
    Push-Location $PSScriptRoot

    #Import all utils
    Get-ChildItem -Path .\utils\*.ps1 | ForEach-Object { . $($_.FullName) }

    # Get and run global scripts
    $ScriptsList = Get-ChildItem ".\$ScriptDir\*.ps1"
    foreach ($CurrentScript in $ScriptsList) {
        & $CurrentScript.FullName
    }

    # Get and run game-specific scripts
    Start-GameAction $Game.Name $ScriptDir

    # Return to original directory
    Pop-Location

    # Wait for all jobs to complete before closing session
    Get-Job | Wait-Job
}