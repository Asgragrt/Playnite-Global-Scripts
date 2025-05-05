<#
    Script to close magpie given that the game has '[SW] Magpie' as a category after closing the game.
#>

$magpiePath = "C:\Program Files\Magpie\Magpie.exe"

# Check if game requires scaling
$gameRequiresScaling = $Game.Categories.Name -contains "[SW] Magpie"
if (!$gameRequiresScaling) {
    Exit 0
}

Close-App 'Magpie' $magpiePath