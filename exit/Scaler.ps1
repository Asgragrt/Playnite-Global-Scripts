<#
    Script to close magpie given that the game has '[SW] Magpie' as a category after closing the game.
#>

$magpiePath = "C:\Program Files\Magpie\Magpie.exe"

# Check if game requires scaling
$gameRequiresScaling = $Game.Categories.Name -contains "[SW] Magpie"
if (!$gameRequiresScaling) {
    return
}

Close-App 'Magpie' $magpiePath