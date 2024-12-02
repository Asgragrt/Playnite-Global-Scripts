$ScriptsPath = "C:\Users\user\Documents\Playnite Global Scripts"
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

    #Use current directory as scripts location
    Push-Location $ScriptsPath

    #Import all utils
    Get-ChildItem -Path .\utils\*.ps1 | ForEach-Object { . $($_.FullName) }

    # Get and run scripts
    $scripts = Get-ChildItem ".\$ScriptDir\*.ps1"
    foreach ($script in $scripts) {
        & $scripts.FullName
    }

    # Return to original directory
    Pop-Location

    # Wait for all jobs to complete before closing session
    Get-Job | Wait-Job
}